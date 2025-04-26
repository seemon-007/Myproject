import 'package:flutter/material.dart';
import 'package:Feedme/Page/login.dart';
import '../BasePage.dart';
import '../Product/product.dart';
import '../Product/product_setting.dart';
import 'Report_Day.dart';
import 'Report_Month.dart';




class ReportPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BasePageadmin(
      index: 1,

      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(title: Text('Report'),backgroundColor: Colors.blue,),

            Padding(padding: const EdgeInsets.all(Sizes.defoult),
              child: Column(
                children: [
                  SizedBox(height: 20, ),
                  ProductSetting(
                    icon: Icons.add_box_outlined ,
                    title: 'สรุปรายวัน',
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => ReportDay()));
                    },
                    backgroundColor: Colors.black12,
                    borderRadius: 15,
                  ),

                  SizedBox(height: 20, ),
                  ProductSetting(
                    icon: Icons.add_box_outlined ,
                    title: 'สรุปรายเดือน',
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => ReportMonth()));
                    },
                    backgroundColor: Colors.black12,
                    borderRadius: 15,
                  ),
                  // Center(
                  //   child: TextButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context, MaterialPageRoute(builder: (_) => LoginPage()));
                  //     },
                  //     child: const Text('Logout', style: TextStyle(color: Colors.red)),
                  //   ),
                  // )
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => LoginPage()));
                      },
                      child: const Text('Logout', style: TextStyle(color: Colors.red)),
                    ),
                  )
                ],
              ),
            ),
          ],

        ),
      ),

    );


  }

}