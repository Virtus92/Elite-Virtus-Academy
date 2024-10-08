import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/woo_commerce/order_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/shop/components/cancel_order_bottomsheet.dart';
import 'package:socialv/screens/shop/components/price_widget.dart';
import 'package:socialv/screens/shop/screens/product_detail_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel orderDetails;

  const OrderDetailScreen({required this.orderDetails});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool isChange = false;

  double subtotal = 0;

  @override
  void initState() {
    super.initState();
    getSubTotal();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> onDeleteOrder() async {
    showConfirmDialogCustom(
      context,
      onAccept: (c) {
        ifNotTester(() {
          appStore.setLoading(true);
          deleteOrder(orderId: widget.orderDetails.id.validate()).then((value) {
            toast(language.orderDeletedSuccessfully);
            appStore.setLoading(false);

            finish(context, true);
          }).catchError((e) {
            appStore.setLoading(false);

            toast(e.toString(), print: true);
          });
        });
      },
      dialogType: DialogType.CONFIRMATION,
      title: language.deleteOrderConfirmation,
      positiveText: language.yes,
      negativeText: language.no,
    );
  }

  Future<void> onCancelOrder() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CancelOrderBottomSheet(
          orderId: widget.orderDetails.id.validate(),
          callback: (text) {
            showConfirmDialogCustom(
              context,
              onAccept: (c) {
                ifNotTester(() {
                  appStore.setLoading(true);
                  cancelOrder(orderId: widget.orderDetails.id.validate(), note: text).then((value) {
                    toast(language.orderCancelledSuccessfully);
                    widget.orderDetails.status = OrderStatus.cancelled;

                    appStore.setLoading(false);
                    isChange = true;
                    setState(() {});
                    //finish(context, true);
                  }).catchError((e) {
                    appStore.setLoading(false);
                    toast(e.toString(), print: true);
                  });
                });
              },
              dialogType: DialogType.CONFIRMATION,
              title: language.cancelOrderConfirmation,
              positiveText: language.yes,
              negativeText: language.no,
            );
          },
        );
      },
    );
  }

  void getSubTotal() {
    widget.orderDetails.lineItems.validate().forEach((element) {
      subtotal = subtotal + element.subtotal.toDouble();
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, isChange);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.iconColor),
            onPressed: () {
              Navigator.pop(context, isChange);
            },
          ),
          titleSpacing: 0,
          title: Text(language.orderDetails, style: boldTextStyle(size: 22)),
          elevation: 0,
          centerTitle: true,
          actions: [
            Theme(
              data: Theme.of(context).copyWith(),
              child: PopupMenuButton(
                enabled: !appStore.isLoading,
                position: PopupMenuPosition.under,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(commonRadius)),
                onSelected: (val) async {
                  if (val == 1) {
                    onDeleteOrder();
                  } else {
                    onCancelOrder();
                  }
                },
                icon: Icon(Icons.more_horiz),
                itemBuilder: (context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Image.asset(ic_delete, width: 20, height: 20, color: Colors.red, fit: BoxFit.cover),
                        8.width,
                        Text(language.deleteOrder, style: primaryTextStyle()),
                      ],
                    ),
                  ),
                  if (widget.orderDetails.status.validate() != OrderStatus.cancelled &&
                      widget.orderDetails.status.validate() != OrderStatus.refunded &&
                      widget.orderDetails.status.validate() != OrderStatus.completed &&
                      widget.orderDetails.status.validate() != OrderStatus.trash &&
                      widget.orderDetails.status.validate() != OrderStatus.failed)
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          Image.asset(ic_close_square, width: 20, height: 20, color: Colors.red, fit: BoxFit.cover),
                          8.width,
                          Text(language.cancelOrder, style: primaryTextStyle()),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${language.orderStatus}:', style: boldTextStyle()),
                      Text(
                        widget.orderDetails.status.validate().capitalizeFirstLetter(),
                        style: boldTextStyle(color: context.primaryColor, size: 18),
                      ),
                    ],
                  ),
                  16.height,
                  Container(
                    decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultAppButtonRadius)),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('${language.orderNumber}:', style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite)),
                            8.width,
                            Text(widget.orderDetails.id.validate().toString(), style: primaryTextStyle()).expand(),
                          ],
                        ),
                        8.height,
                        Row(
                          children: [
                            Text('${language.date}:', style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite)),
                            8.width,
                            Text(formatDate(widget.orderDetails.dateCreated.validate().toString()), style: primaryTextStyle()).expand(),
                          ],
                        ),
                        8.height,
                        Row(
                          children: [
                            Text('${language.email}:', style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite)),
                            8.width,
                            Text(userStore.loginEmail, style: primaryTextStyle()).expand(),
                          ],
                        ),
                        8.height,
                        Row(
                          children: [
                            Text('${language.paymentMethod}:', style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite)),
                            8.width,
                            Text(widget.orderDetails.paymentMethodTitle.validate(), style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis).expand(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  16.height,
                  Text('${language.cartTotals}:', style: boldTextStyle()),
                  16.height,
                  Container(
                    decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultAppButtonRadius)),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: widget.orderDetails.lineItems!.length,
                          itemBuilder: (ctx, index) {
                            LineItem item = widget.orderDetails.lineItems.validate()[index];

                            return Row(
                              children: [
                                cachedImage(
                                  item.image!.src.validate(),
                                  height: 30,
                                  width: 30,
                                  fit: BoxFit.cover,
                                ).cornerRadiusWithClipRRect(commonRadius),
                                8.width,
                                Text(
                                  '${item.name.validate()} * ${item.quantity.validate()}',
                                  style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ).expand(),
                                PriceWidget(
                                  regularPrice: item.subtotal.validate(),
                                  salePrice: item.total.validate(),
                                  price: item.total.validate(),
                                ),
                              ],
                            ).paddingSymmetric(vertical: 6).onTap(() {
                              ProductDetailScreen(id: item.productId.validate()).launch(context);
                            }, splashColor: Colors.transparent, highlightColor: Colors.transparent);
                          },
                        ),
                        if (widget.orderDetails.couponLines.validate().isNotEmpty) ...[
                          Divider(height: 32),
                          Text(language.appliedCoupons, style: boldTextStyle(size: 14)),
                          8.height,
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.orderDetails.couponLines.validate().length,
                            itemBuilder: (ctx, index) {
                              OrderCouponModel coupon = widget.orderDetails.couponLines.validate()[index];
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${language.couponCode}: ${coupon.code}', style: secondaryTextStyle()),
                                  PriceWidget(price: coupon.discount.validate()),
                                ],
                              );
                            },
                          ),
                        ],
                        Divider(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${language.subTotal}:', style: boldTextStyle()),
                            PriceWidget(price: subtotal.toString()),
                          ],
                        ),
                        if (widget.orderDetails.discountTotal.validate() != '0.00')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${language.discount}:', style: boldTextStyle()),
                              PriceWidget(price: widget.orderDetails.discountTotal.validate()),
                            ],
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${language.total}:', style: boldTextStyle()),
                            PriceWidget(price: widget.orderDetails.total.validate()),
                          ],
                        ),
                      ],
                    ),
                  ),
                  16.height,
                  Text('${language.billingAddress}:', style: boldTextStyle()),
                  16.height,
                  Container(
                    decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(defaultAppButtonRadius)),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${language.name}:', style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite)),
                            8.width,
                            Text(widget.orderDetails.billing!.firstName.validate().toString(), style: primaryTextStyle()),
                          ],
                        ),
                        8.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${language.company}:', style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite)),
                            8.width,
                            Text(widget.orderDetails.billing!.company.validate().toString(), style: primaryTextStyle()),
                          ],
                        ),
                        8.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${language.address}:', style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite)),
                            8.width,
                            Text('${widget.orderDetails.billing!.address_1.validate().toString()}, ${widget.orderDetails.billing!.address_2.validate().toString()}', style: primaryTextStyle())
                                .expand(),
                          ],
                        ),
                        8.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${language.city}:', style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite)),
                            8.width,
                            Text(widget.orderDetails.billing!.city.validate().toString().capitalizeFirstLetter(), style: primaryTextStyle()),
                          ],
                        ),
                        8.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${language.state}:', style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite)),
                            8.width,
                            Text(widget.orderDetails.billing!.state.validate().toString(), style: primaryTextStyle()),
                          ],
                        ),
                        8.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${language.country}:', style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite)),
                            8.width,
                            Text(widget.orderDetails.billing!.country.validate().toString(), style: primaryTextStyle()),
                          ],
                        ),
                        8.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${language.phone}:', style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite)),
                            8.width,
                            Text(widget.orderDetails.billing!.phone.validate().toString(), style: primaryTextStyle()).expand(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Observer(builder: (ctx) => LoadingWidget().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
