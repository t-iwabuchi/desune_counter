// reference : http://rukae.hatenablog.com/entry/2019/01/07/190000

import java.io.IOException;
import processing.net.*;
import javax.swing.*;
import java.awt.*;

//ウィンドウサイズ
int wWidth  = 500;
int wHeight = 500;

Client myClient; //Juliusとの連携
JLayeredPane pane;
JTextField field;
JTextArea area;
String desune;  //検索ワード
int count; //検索ワードを言われた回数
long startTime; //単語を見つけた瞬間からの時間

void settings() {
  size(wWidth, wHeight);
}

void setup () {
  desune = "ですね";
  count = 0;

  // Juliusに接続
  myClient = new Client(this,"localhost",10500);

  // SmoothCanvasの親の親にあたるJLayeredPaneを取得
  Canvas canvas = (Canvas) surface.getNative();
  pane = (JLayeredPane) canvas.getParent().getParent();
}

void draw () {
  if (startTime == 0)
    background(#FACACA);
  else
    background(0,255,0);
  
  // 1行のみのテキストボックスを作成
  field = new JTextField(desune);
  field.setBounds(10, 10, wWidth/2 - 10, 100);
  field.setHorizontalAlignment(JTextField.CENTER);
  field.setFont(new Font("ＭＳ ゴシック", Font.PLAIN, 48));
  pane.add(field);
  desune = field.getText();

  // 「カウンター」の文字を表示
  fill(0);
  PFont font = createFont("MS Gothic",48,true);
  textFont(font); // 選択したフォントを指定する
  textSize(50);
  text("カウンター", wWidth/2, 100-20);

  // desune の値を表示
  fill(0);
  textFont(font); // 選択したフォントを指定する
  textSize(50);
  text(desune, wWidth/9, wHeight/2);
  
  // 「回」を表示
  fill(255,0,0);
  text(count, wWidth/10*6, wHeight/2);
  fill(0,0,0);
  text("回", wWidth/10*8, wHeight/2);

  // 発声されている語を取得
  desune = field.getText();
  String word = getWord(); // Juliusから取得した言葉
  if(word.contains(desune)) // 検索ワードを発見
  {
      count++;
      startTime = millis();
  }
  
  if (millis() - startTime >= 2000)
    startTime = 0;
}

// Juliusから言葉を取得
String getWord() {
    String word = "";
    if (myClient.available()>0){
        String dataIn = myClient.readString();
        String[] sList = split(dataIn, "WORD");
        for(int i=1;i<sList.length;i++){
            String tmp = sList[i];
            String[] tList = split(tmp, '"');
            word += tList[1];
        }
    }
    if (word != ""){
        println(word);
    }
    return word;
}
