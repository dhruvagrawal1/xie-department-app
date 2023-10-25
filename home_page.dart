import 'package:college_manager/widgets/tt_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_carousel_slider/flutter_custom_carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../utils/timeTable.dart';

void main() {
  runApp(
    ProviderScope(
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return const MaterialApp(
            home: HomePage(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    ),
  );
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<CarouselItem> items = [
    CarouselItem(image: const AssetImage('assets/images/log.png')),
    CarouselItem(image: const AssetImage('assets/images/log.png')),
    CarouselItem(image: const AssetImage('assets/images/log.png')),
    CarouselItem(image: const AssetImage('assets/images/log.png'))
  ];
  List<String> tt = [];
  late List<Map<String, dynamic>> lectures;

  @override
  void initState() {
    setLectures();
    super.initState();
  }

  void getLectures() {
    int currentDay = DateTime.now().weekday;
    switch (currentDay) {
      case DateTime.monday:
        tt = monday;
        break;
      case DateTime.tuesday:
        tt = tuesday;
        break;
      case DateTime.wednesday:
        tt = wednesday;
        break;
      case DateTime.thursday:
        tt = thursday;
        break;
      case DateTime.friday:
        tt = friday;
        break;
      default:
        return;
    }
  }

  void setLectures() {
    getLectures();
    lectures = [
      {'name': tt[0], 'start': "8:45AM", 'end': "9:45AM"},
      {'name': tt[1], 'start': "9:45AM", 'end': "10:45AM"},
      {'name': 'Short Break', 'start': "10:45AM", 'end': "11:00AM"},
      {'name': tt[2], 'start': "11:00AM", 'end': "12:00PM"},
      {'name': tt[3], 'start': "12:00PM", 'end': "1:00PM"},
      {'name': 'Break', 'start': "1:00PM", 'end': "1:30PM"},
      {'name': tt[4], 'start': "1:30PM", 'end': "2:30PM"},
      {'name': tt[5], 'start': "2:30PM", 'end': "3:30PM"},
      {'name': tt[6], 'start': "3:30PM", 'end': "4:30PM"},
    ];
  }

  String determineStatus(int index, List<Map<String, dynamic>> lectures) {
    DateTime now = DateTime.now();

    DateTime startTime = DateTime(now.year, now.month, now.day).add(
        DateFormat("h:mma")
            .parse(lectures[index]['start'])
            .difference(DateTime(1970)));
    DateTime endTime = DateTime(now.year, now.month, now.day).add(
        DateFormat("h:mma")
            .parse(lectures[index]['end'])
            .difference(DateTime(1970)));

    // Check if the lecture is ongoing
    if (now.isAfter(startTime) && now.isBefore(endTime)) {
      return "ongoing";
    }

    if (now.isAfter(endTime)) {
      return "done";
    }

    if (index > 0) {
      DateTime prevEndTime = DateTime(now.year, now.month, now.day).add(
          DateFormat("h:mma")
              .parse(lectures[index - 1]['end'])
              .difference(DateTime(1970)));
      if (now.isAfter(prevEndTime) && now.isBefore(startTime)) {
        return "next lecture";
      }
    }

    return "upcoming";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              size: 4.2.h,
            ),
            color: const Color(0xFF000080),
            onPressed: () {},
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: Image.asset(
                "assets/images/xie.png",
                width: 10.w,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CustomCarouselSlider(
                  items: items,
                  height: 28.h,
                  width: MediaQuery.of(context).size.width / 1.1,
                  autoplay: true,
                  showText: false,
                  showSubBackground: false,
                  indicatorShape: BoxShape.circle,
                  indicatorPosition: IndicatorPosition.bottom,
                  selectedDotColor: const Color(0xFF000080),
                  unselectedDotColor: Colors.grey,
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Today’s Timeline',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "${DateFormat.E().format(DateTime.now())}, ${DateFormat.yMMMd().format(DateTime.now())}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(
                      height: 6.h, // Define a specific height for the list
                      child: DateTime.now().weekday == 6 ||
                              DateTime.now().weekday == 7
                          ? ListView.builder(
                              itemCount: 9,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                String status =
                                    determineStatus(index, lectures);
                                return Row(
                                  children: [
                                    TTCard(
                                        classRoom: "LH-5",
                                        subject: lectures[index]["name"],
                                        time:
                                            "${lectures[index]["start"]}-${lectures[index]["end"]}",
                                        status: status),
                                    SizedBox(
                                      width: 3.5.w,
                                    ),
                                  ],
                                );
                              },
                            )
                          : const Text("No Lectures Today!!"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
