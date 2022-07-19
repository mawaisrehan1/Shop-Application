import 'package:shop_application/screens/cart_screen.dart';
import 'package:shop_application/screens/edit_product_screen.dart';
import 'package:shop_application/screens/orders_screen.dart';
import 'package:shop_application/screens/product_detail_screen.dart';
import 'package:shop_application/screens/user_products_screen.dart';

import '../screens/products_overview_screen.dart';


//BuildContext? context;

class Routes{

  static String productOverviewScreen = '/productOverviewScreen';
  static String productDetailScreen = "/productDetailScreen";
  static String cartScreen = "/cartScreen";
  static String ordersScreen = "/ordersScreen";
  static String userProductsScreen = "/userProductsScreen";
  static String editProductScreen = "/editProductScreen";


  static getRoutes(){
    return {
      productOverviewScreen:(context) =>  const ProductOverviewScreen(),
      productDetailScreen:(context) =>  const ProductDetailScreen(),
       cartScreen:(context) => const CartScreen(),
      ordersScreen:(context) => const OrdersScreen(),
      userProductsScreen:(context) => const UserProductsScreen(),
      editProductScreen:(context) => const EditProductScreen(),

    };
  }
}




