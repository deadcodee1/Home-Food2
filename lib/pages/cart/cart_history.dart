import 'package:flutter/material.dart';
import 'package:home_food_delivery/controllers/cart_controller.dart';
import 'package:home_food_delivery/utils/Colors.dart';
import 'package:home_food_delivery/utils/app_constants.dart';
import 'package:home_food_delivery/utils/dimensions.dart';
import 'package:home_food_delivery/widgets/app_icon.dart';
import 'package:home_food_delivery/widgets/small_text.dart';
import 'package:intl/intl.dart';
import '../../widgets/big_text.dart';
import 'package:get/get.dart';

class CartHistory extends StatelessWidget {
  const CartHistory({super.key});

  @override
  Widget build(BuildContext context) {
    var getCartHistoryList =
        Get.find<CartController>().getCartHistoryList().reversed.toList();

    Map<String, int> cartItemsPerOrder = Map();

    for (int i = 0; i < getCartHistoryList.length; i++) {
      if (cartItemsPerOrder.containsKey(getCartHistoryList[i].time)) {
        cartItemsPerOrder.update(
            getCartHistoryList[i].time!, (value) => ++value);
      } else {
        cartItemsPerOrder.putIfAbsent(getCartHistoryList[i].time!, () => 1);
      }
    }

    List<int> cartOrderTimeToList() {
      return cartItemsPerOrder.entries.map((e) => e.value).toList();
    }

    List<int> itemsPerOrder = cartOrderTimeToList();

    var listCounter = 0;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 100,
            color: AppColors.mainColor,
            width: double.maxFinite,
            padding: const EdgeInsets.only(top: 45, right: 35, left: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BigText(
                  text: "Cart History",
                  color: Colors.white,
                ),
                AppIcon(
                  icon: Icons.shopping_cart,
                  backgroundColor: AppColors.mainColor,
                  iconColor: Colors.white,
                  iconSize: Dimensions.iconSize24,
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
                  margin: EdgeInsets.only(
                      top: Dimensions.height20,
                      left: Dimensions.width20,
                      right: Dimensions.width20),
                  child: MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView(
                      children: [
                        for (int i = 0; i < itemsPerOrder.length; i++)
                          Container(
                            height: 120,
                            margin:
                                EdgeInsets.only(bottom: Dimensions.height20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (() {
                                  DateTime parseDate =
                                      DateFormat("yyyy-mm-dd HH:mm:ss").parse(
                                          getCartHistoryList[listCounter]
                                              .time!);
                                  var inputDate =
                                      DateTime.parse(parseDate.toString());
                                  var outputFormat =
                                      DateFormat("MM/dd/yyyy hh:mm a");
                                  var outputDate =
                                      outputFormat.format(inputDate);
                                  return BigText(text: outputDate);
                                }()),
                                SizedBox(
                                  height: Dimensions.height10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      direction: Axis.horizontal,
                                      children: List.generate(itemsPerOrder[i],
                                          (index) {
                                        if (listCounter <
                                            getCartHistoryList.length) {
                                          listCounter++;
                                        }
                                        return index <= 2
                                            ? Container(
                                                height: 80,
                                                width: 80,
                                                margin: EdgeInsets.only(
                                                    right:
                                                        Dimensions.width10 / 2),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                    .radius15 /
                                                                2),
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            AppConstants
                                                                    .BASE_URL +
                                                                AppConstants
                                                                    .UPLOAD_URL +
                                                                getCartHistoryList[
                                                                        listCounter -
                                                                            1]
                                                                    .img!))),
                                              )
                                            : Container();
                                      }),
                                    ),
                                    Container(
                                      height: 80,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          SmallText(
                                            text: "Total",
                                            color: AppColors.titleColor,
                                          ),
                                          BigText(
                                            text: itemsPerOrder[i].toString() +
                                                " Items",
                                            color: AppColors.titleColor,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Dimensions.width10,
                                                vertical:
                                                    Dimensions.height10 / 2),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radius15 / 3),
                                              border: Border.all(
                                                  width: 1,
                                                  color: AppColors.mainColor),
                                            ),
                                            child: SmallText(
                                              text: "one more",
                                              color: AppColors.mainColor,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  )))
        ],
      ),
    );
  }
}
