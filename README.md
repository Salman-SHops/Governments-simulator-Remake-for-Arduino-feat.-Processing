1.作品の説明<br>
この作品では図のブレッドボード上に搭載されているセンサー類を操作することでモニターに描画されるセミオートピストル「M1911」を操作することが出来る。
センサー類の説明をすると、ボード上の左にあるタクトスイッチがトリガーであり、右隣りの三色LEDは弾丸を発射可能かどうかを赤と青で出力し、隣のボリュームは銃のスライドを動かすことができ、その隣に4つ並ぶタクトスイッチの役割は、左から順にマガジンストップ、セーフティ、スライドストップ、ハンマーをそれぞれ操作することが出来る。そしてCDSセルでは拳銃の機構であるグリップセーフティの握るという動作を再現し、タッチセンサーではマガジンを操作することが出来る。
銃弾を発射するにはそれぞれのセンサーを操作し、適切な手順を踏むことで発射が可能になる。セーフティがかかっていたり、タッチセンサーを握らなかったり、薬室内に弾が装填されていなかったりすると発射することはできない。
<br><br>
2.開発環境<br>
Proccesing v4.3<br>
-使用ライブラリ<br>
  ・processing.serial<br>
  ・cc.arudino          ProcessingとArduinoマイコンボード間でシリアル通信を行うライブラリ<br>
  ・ddf.minim<br>
  ・ddf.minim.signals<br>
  ・ddf.minim.analysis<br>
  ・ddf.minim.effects   画像ファイルや音声ファイルをインポートするためのライブラリ<br>
<br>
Arduino IDE v2.3.2<br>
-使用ライブラリ<br>
  ・Firmata    ProcessingとArduinoマイコンボード間でシリアル通信を行うライブラリ<br>
-使用スケッチ例<br>
  ・StandardFirmata.ino  Firmataライブラリに標準搭載されているスケッチ
<br><br>

動作映像<br>
1.手元あり<br>
  https://drive.google.com/file/d/1QbabH1KNdrxLK8b3NKK4eTqkySO1s-gI/view?usp=drive_link <br>
2.モニターのみ<br>
  https://drive.google.com/file/d/1M_RTEDwu1chRtl997a5W5RXaCcHrx2Fz/view?usp=drive_link <br>
