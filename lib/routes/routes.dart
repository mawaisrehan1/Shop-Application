import 'package:shop_application/screens/product_detail_screen.dart';

import '../screens/products_overview_screen.dart';


//BuildContext? context;

class Routes{

  static String productOverviewScreen = '/productOverviewScreen';
  static String productDetailScreen = "/productDetailScreen";


  static getRoutes(){
    return {
      productOverviewScreen:(context) =>  ProductOverviewScreen(),
      productDetailScreen:(context) =>  ProductDetailScreen(),
      // categoriesScreen:(context) => const CategoriesScreen(),

    };
  }

}




