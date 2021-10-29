import 'package:flutter/material.dart';
import 'package:saag_sabji/helper/page_transition_fade_animation.dart';
import 'package:saag_sabji/response/get_categories_response.dart';
import 'package:saag_sabji/ui/get_products_by_selected_category_ui.dart';

class Category extends StatelessWidget {
  Response categoryItem;

  Category(this.categoryItem);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(categoryItem.categoryId.toString());
        Navigator.push(context, FadeRoute(page: ShowProductsUI(categoryItem)));
      },
      child: Padding(
        padding: EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              elevation: 2,
              shadowColor: Colors.orangeAccent,
              child: CircleAvatar(
                backgroundImage: NetworkImage(categoryItem.image),
                maxRadius: 30,
                backgroundColor: Colors.orange,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              categoryItem.name,
              maxLines: 1,
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
