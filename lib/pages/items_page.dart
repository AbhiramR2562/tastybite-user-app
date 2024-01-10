import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tastybite/global/global.dart';
import 'package:tastybite/models/items.dart';
import 'package:tastybite/models/menus.dart';
import 'package:tastybite/widgets/app_bar.dart';
import 'package:tastybite/widgets/item_design.dart';
import 'package:tastybite/widgets/sellers_design.dart';
import 'package:tastybite/widgets/my_drawer.dart';
import 'package:tastybite/widgets/text_widget_header.dart';

class ItemsPage extends StatefulWidget {
  final Menus? model;
  const ItemsPage({super.key, this.model});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(sellerUID: widget.model!.sellerUID),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextWidgetHeader(
              title: "Items of " + widget.model!.menuTitle.toString(),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(widget.model!.sellerUID)
                .collection("menus")
                .doc(widget.model!.menuID)
                .collection("items")
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
                        Items model = Items.fromJson(
                          snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>,
                        );
                        return ItemDesignWidget(
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
