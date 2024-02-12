import 'package:car_registration/models/carModel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:searchable_listview/searchable_listview.dart';

class MyFirebaseSearchableList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController search = TextEditingController();
    double heightM = MediaQuery.of(context).size.height / 30;
    Color button_color = Color.fromARGB(255, 50, 173, 230);
    Color txt_color = Color.fromARGB(255, 75, 73, 74);

    List<carModel> carsList = [];

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('Cars')
          .where('userId', isEqualTo: "A")
          .get(),
      //
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print(" Error retrieving data: ${snapshot.error}");
          return Center(
            child: Column(
              children: [
                SizedBox(
                  height: heightM * 3.5,
                ),
                Image.network(
                    "https://img.freepik.com/premium-vector/no-data-concept-illustration_86047-488.jpg",
                    height: heightM * 8.50,
                    fit: BoxFit.fill),
                Text(
                  "Oops! No vehicles have been added yet. Please navigate to the 'Add Vehicle' page to add a new vehicle.",
                  style: inputTextStyle(
                      txt_color: txt_color, txt_size: heightM * 0.6),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    color: button_color,
                  )));
        }

        List<String> dataList = snapshot.data!.docs.map((doc) {
          //
          carModel carr = carModel(
            userId: doc.get('userId') as String,
            managerId: doc.get('managerId') as String,
            carPlate: doc.get('carPlate') as String,
            phoneNumber: doc.get('phoneNumber') as String,
            MakerEn: doc.get('MakerEn') as String,
            makerAr: doc.get('makerAr') as String,
            date: doc.get('date'),
            statusAr: doc.get('statusAr') as String,
            statusEn: doc.get('statusEn') as String,
          );
          carsList.add(carr);
          return doc.get('carPlate') as String;
        }).toList();

        return SearchableList<String>(
            emptyWidget: const EmptyView(),
            listViewPadding:
                EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(carsList[index].MakerEn,
                                  style: ourTextStyle(
                                      txt_color: txt_color,
                                      txt_size: heightM * 0.5)),
                              Text(carsList[index].carPlate,
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
            initialList: dataList,
            // filter: (p0) {
            //   return actors
            //       .where((element) => element.name.contains(p0))
            //       .toList();
            // },
            inputDecoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
            closeKeyboardWhenScrolling: true);
      },
    );
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

TextStyle ourTextStyle({required Color txt_color, required double txt_size}) {
  return GoogleFonts.cairo(
      color: txt_color, fontWeight: FontWeight.bold, fontSize: txt_size);
}

TextStyle inputTextStyle({required Color txt_color, required double txt_size}) {
  return GoogleFonts.cairo(
      color: txt_color, fontWeight: FontWeight.w500, fontSize: txt_size);
}
