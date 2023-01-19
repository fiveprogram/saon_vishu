import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/domain/information_salon_detail.dart';
import 'package:salon_vishu/profile/salon_info/salon_info_model.dart';

class SalonInfoPage extends StatefulWidget {
  const SalonInfoPage({Key? key}) : super(key: key);

  @override
  State<SalonInfoPage> createState() => _SalonInfoPageState();
}

class _SalonInfoPageState extends State<SalonInfoPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    Container informationListTile(
        {required String column,
        required String detail,
        required double tileMargin}) {
      return Container(
        width: width,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black54,
            ),
          ),
        ),
        child: Row(
          children: [
            Text(column,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            SizedBox(width: tileMargin),
            Expanded(
              child: Text(
                detail,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget buildImage(String path, int index) {
      return Container(
        height: height * 0.8,
        width: width,
        color: Colors.orange,
        child: Image.network(
          path,
          fit: BoxFit.cover,
        ),
      );
    }

    return Scaffold(
      backgroundColor: HexColor('#fcf8f6'),
      appBar: vishuAppBar(appBarTitle: 'サロン情報', isJapanese: true),
      body: Consumer<SalonInfoModel>(
        builder: (context, model, child) {
          if (model.info == null) {
            return const CircularProgressIndicator();
          }
          InformationSalonDetail info = model.info!;

          return SingleChildScrollView(
            controller: model.scrollController,
            child: Column(
              children: [
                CarouselSlider.builder(
                  itemCount: info.vishuImagesList.length,
                  itemBuilder: (context, index, int pageViewIndex) {
                    String path = info.vishuImagesList[index];
                    return buildImage(path, index);
                  },
                  carouselController: model.buttonCarouselController,
                  options: CarouselOptions(
                      initialPage: 0,
                      viewportFraction: 1,
                      onPageChanged: (math, reason) {
                        setState(() {
                          model.activeIndex = math;
                        });
                      }),
                ),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < info.vishuImagesList.length; i++)
                      Container(
                        height: height * 0.015,
                        width: width * 0.06,
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: model.activeIndex == i
                                ? Colors.brown
                                : Colors.white70,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black45, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.white,
                                  spreadRadius: 1,
                                  offset: Offset(2, 2))
                            ]),
                      )
                  ],
                ),
                SizedBox(height: height * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Text(
                        'プライベートサロンでゆっくり1人の癒し時間♪ヘッドスパで日頃の疲れをリフレッシュ♪システムTRで艶髪に',
                        style: TextStyle(
                            color: HexColor('#ff7070'),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: height * 0.02),
                      const Text(
                        'プライベートサロンで他のお客様を気にしなくて良い空間♪ハーブカラーでダメージを抑えて♪パーマは髪に優しいコスメパーマ★縮毛矯正♪髪質改善＋トリートメントしながらツヤ髪に♪全メニュートリートメント配合のセットメニューがお得です☆シャンプー台は首に負担がかからないのでヘッドスパが人気です☆是非体験を★',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.04),
                Container(
                  alignment: Alignment.center,
                  height: height * 0.05,
                  decoration: BoxDecoration(
                      color: HexColor('#594840'),
                      border: const Border(
                          bottom: BorderSide(color: Colors.black26),
                          top: BorderSide(color: Colors.black26))),
                  child: const Text('スタイリスト',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: height * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: height * 0.2,
                      width: width * 0.3,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black87),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(info.stylistImage),
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.04),
                    SizedBox(
                      width: width * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ちよこ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'チヨコ',
                            style:
                                TextStyle(fontSize: 15, color: Colors.black87),
                          ),
                          Text(
                            info.skillYear,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black54),
                          ),
                          SizedBox(height: height * 0.02),
                          Text(info.ownerWord),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: height * 0.02),
                Container(
                  alignment: Alignment.center,
                  height: height * 0.05,
                  decoration: BoxDecoration(
                      color: HexColor('#594840'),
                      border: const Border(
                          bottom: BorderSide(color: Colors.black26),
                          top: BorderSide(color: Colors.black26))),
                  child: const Text('サロンから一言',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: height * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: height * 0.2,
                      width: width * 0.3,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black87),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(info.vishuImage),
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.04),
                    SizedBox(
                      width: width * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Salon Vishu',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'サロン  ヴィッシュ',
                            style:
                                TextStyle(fontSize: 15, color: Colors.black87),
                          ),
                          Text(
                              '木目ベースのシンプルで温かみのある店内でアットホームなプライベートサロンです♪一人のスタッフが最初から最後まで担当するので些細なことも相談しやすく、心から寛げるサロンです。セットメニューがお得です♪＊地域に愛されるようなサロンを目指し、居心地の良い空間をご提供いたします。※マンツーマンサロンなので施術中は電話に出れないことがあります。')
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: height * 0.04),
                Container(
                  alignment: Alignment.center,
                  height: height * 0.05,
                  decoration: BoxDecoration(
                      color: HexColor('#594840'),
                      border: const Border(
                          bottom: BorderSide(color: Colors.black26),
                          top: BorderSide(color: Colors.black26))),
                  child: const Text('サロンデータ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
                informationListTile(
                    column: 'サロン情報',
                    detail: ' Salon Vishu\n【サロンヴィッシュ】',
                    tileMargin: width * 0.05),
                informationListTile(
                    column: '電話番号',
                    detail: '0721-21-8824',
                    tileMargin: width * 0.1),
                informationListTile(
                    column: '住所',
                    detail: '大阪府河内長野市荘園町18-14',
                    tileMargin: width * 0.18),
                informationListTile(
                    column: 'アクセス',
                    detail: '南海高野線千代田駅から荘園町行きバス15分　荘園町下車徒歩3分',
                    tileMargin: width * 0.1),
                informationListTile(
                    column: '道案内',
                    detail:
                        '170号線を河内長野警察方面へ曲がり直進赤峰交差点小山田小学校前直進荘園橋を渡り酒屋を越えて一つ目の筋を右へ道なりに十字路３つ越えてY字路左にカーブした角すぐの白と黒の建物です。310号線からの場合千代田駅をスーパー西友方面へ曲がり寺ヶ池方面へ赤峰交差点右に小山田小学前を通り荘園橋を渡り酒屋を越えて一つ目の筋を右へ道なりに十字路３つ越えてY字路左にカーブした角すぐの白と黒の建物です。★農道は危険です ',
                    tileMargin: width * 0.14),
                informationListTile(
                    column: '営業時間',
                    detail: '9:00～18:00（カット最終17:00）',
                    tileMargin: width * 0.1),
                informationListTile(
                    column: '定休日',
                    detail: '不定休　（お問い合わせください）',
                    tileMargin: width * 0.14),
                informationListTile(
                    column: '支払い方法',
                    detail: 'VISA／MasterCard／JCB／American Express／PayPay ',
                    tileMargin: width * 0.05),
                informationListTile(
                    column: 'カット価格',
                    detail: '¥3,800 ',
                    tileMargin: width * 0.05),
                informationListTile(
                    column: '席数', detail: 'セット面1席 ', tileMargin: width * 0.18),
                informationListTile(
                    column: 'スタッフ数',
                    detail: 'スタイリスト1人',
                    tileMargin: width * 0.05),
                informationListTile(
                    column: '駐車場', detail: '店前砂利駐車場', tileMargin: width * 0.14),
                informationListTile(
                    column: 'こだわり条件',
                    detail:
                        '４席以下の小型サロン／駐車場あり／一人のスタイリストが仕上げまで担当／ヘアセット／着付け／朝１０時前でも受付OK／カード支払いOK／禁煙／完全予約制',
                    tileMargin: width * 0.05),
                informationListTile(
                    column: '備考',
                    detail:
                        'お車でお越しの方へ,ナビゲーションが案内する農道は危険なので通らないで下さい。赤峰交差点、小山田小学校前を通ってお越し下さい。お願い致します。',
                    tileMargin: width * 0.18),
                SizedBox(height: height * 0.02),
                const Text('salon Vishu',
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        fontFamily: 'Dancing_Script')),
                const Text(
                  'バージョン　1.0.0',
                  style: TextStyle(),
                ),
                SizedBox(height: height * 0.02),
                SizedBox(
                  width: width * 0.6,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.brown),
                      onPressed: () {
                        model.scrollController.animateTo(0,
                            duration: const Duration(milliseconds: 5),
                            curve: Curves.linear);
                      },
                      child: const Text('トップに戻る')),
                ),
                SizedBox(height: height * 0.02),
              ],
            ),
          );
        },
      ),
    );
  }
}
