import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tastybite/assistantMethod/assistant_method.dart';
import 'package:tastybite/global/global.dart';
import 'package:tastybite/models/menus.dart';
import 'package:tastybite/models/sellers.dart';
import 'package:tastybite/pages/splash_page.dart';
import 'package:tastybite/widgets/menu_design.dart';
import 'package:tastybite/widgets/sellers_design.dart';
import 'package:tastybite/widgets/my_drawer.dart';
import 'package:tastybite/widgets/text_widget_header.dart';

class MenusPage extends StatefulWidget {
  final Sellers? model;
  const MenusPage({super.key, this.model});

  @override
  State<MenusPage> createState() => _MenusPageState();
}

class _MenusPageState extends State<MenusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.orange,
                  Colors.red,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        title: Text(
          "TASTY BITE",
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () {
            clearCartNow(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SplashPage()));

            Fluttertoast.showToast(msg: "Cart has been cleared successfully..");
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextWidgetHeader(
              title: widget.model!.sellerName.toString() + " Menu",
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(widget.model!.sellerUID)
                .collection("menus")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: ((context, snapshot) {
              return !snapshot.hasData
                  ? const SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        Menus model = Menus.fromJson(
                          snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>,
                        );
                        return MenuDesignWidget(
                          model: model,
                          context: context,
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
            }),
          )
        ],
      ),
    );
  }
}
