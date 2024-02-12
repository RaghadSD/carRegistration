import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:line_icons/line_icons.dart';
import 'package:searchable_listview/searchable_listview.dart';
// import 'package:line_icons/line_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController search = TextEditingController();

  List<String> itemList = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  List<String> itemList2 = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  List<String> itemList3 = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  List<String> itemList4 = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double heightM = MediaQuery.of(context).size.height / 30;
    Color button_color = Color.fromARGB(255, 50, 173, 230);
    Color txt_color = Color.fromARGB(255, 75, 73, 74);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: heightM * 3,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 20.0),
              child: Text(
                "Received Vehicles",
                style:
                    ourTextStyle(txt_size: heightM * 0.8, txt_color: txt_color),
              ),
            ),
            SizedBox(
              height: heightM * 0.25,
            ),
            Container(
                // width: 500,
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                margin: EdgeInsets.zero,
                child: TabBar(
                  onTap: (value) {
                    print(value);
                    print(_tabController.index);
                  },
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  controller: _tabController,
                  indicatorPadding:
                      EdgeInsets.zero, // Set indicatorPadding to zero
                  dividerColor: Color.fromARGB(0, 224, 18, 18),
                  // indicatorColor: Color.fromARGB(255, 224, 18, 18),
                  labelColor: Color.fromARGB(255, 255, 255, 255),
                  labelStyle: inputTextStyle(
                      txt_color: txt_color, txt_size: heightM * 0.55),
                  tabs: [
                    new Tab(text: "Receivied"),
                    new Tab(text: "Confirmed receiption"),
                    new Tab(text: "Delivered"),
                    new Tab(text: "Confirm Delivery")
                  ],
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BubbleTabIndicator(
                    indicatorHeight: 30.0,
                    indicatorColor: button_color,
                    tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    insets: EdgeInsets.all(1),
                  ),
                )),
            SizedBox(
              height: heightM * 0.2,
            ),
            SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Center(
                  child: Container(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets
                          .zero, // Adjust the margin or padding as needed
                      height: 640,
                      width: 410,
                      child: SearchableList<String>(
                          emptyWidget: const EmptyView(),
                          listViewPadding: EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 10.0),
                          displaySortWidget: true,
                          sortPredicate: (a, b) => a.compareTo(b),
                          // sortPredicate: (a, b) => a.age.compareTo(b.age),
                          defaultSuffixIconColor: Colors.grey,
                          searchTextController: search,
                          onSubmitSearch: (value) {
                            search.text = value!;
                          },
                          spaceBetweenSearchAndList: 0,
                          builder: (list, index, item) {
                            // return ActorItem(actor: item);
                            // onItemSelected:,
                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(0, 238, 238, 238),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.grey[200],
                                          radius: 25,
                                          child: Icon(
                                            LineIcons.carSide,
                                            color: button_color,
                                            size: 30,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('ABC2012',
                                                style: ourTextStyle(
                                                    txt_color: txt_color,
                                                    txt_size: heightM * 0.5)),
                                            Text('Audi',
                                                style: inputTextStyle(
                                                    txt_color: txt_color,
                                                    txt_size: heightM * 0.5)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(),
                              ],
                            );
                          },
                          initialList: itemList,
                          // filter: (p0) {
                          //   return actors
                          //       .where((element) => element.name.contains(p0))
                          //       .toList();
                          // },
                          inputDecoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: button_color,
                              ),
                            ),
                            labelStyle: inputTextStyle(
                                txt_color: txt_color, txt_size: heightM * 0.45),
                            labelText: 'Search',
                            border: OutlineInputBorder(),
                            fillColor: Colors.white,
                          ),
                          closeKeyboardWhenScrolling: true)),
                ))
          ],
        ),
      ),
    );
  }

  TextStyle ourTextStyle({required Color txt_color, required double txt_size}) {
    return GoogleFonts.cairo(
        color: txt_color, fontWeight: FontWeight.bold, fontSize: txt_size);
  }

  TextStyle inputTextStyle(
      {required Color txt_color, required double txt_size}) {
    return GoogleFonts.cairo(
        color: txt_color, fontWeight: FontWeight.w500, fontSize: txt_size);
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.error,
          color: Colors.red,
        ),
        Text('no actor is found with this name'),
      ],
    );
  }
}
