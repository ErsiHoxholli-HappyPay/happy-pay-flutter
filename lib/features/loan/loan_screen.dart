import 'package:flutter/material.dart';
import '../../widgets/app_bottom_navigation.dart';
import '../../widgets/app_header.dart';

class LoanScreen extends StatelessWidget {

  const LoanScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppHeader(
                            title: "Loan",
                            currentIndex: 2,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height:35),

                    Center(
                      child: Column(
                        children: [
                          const Text(
                            "Available limit",
                            style:
                            TextStyle(
                              color:
                              Colors.grey,
                              fontSize:
                              12,
                            ),
                          ),

                          const SizedBox(height:5),

                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children:[
                              const Text(
                                "L800",
                                style:
                                TextStyle(
                                  fontSize:
                                  32,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              const SizedBox(width:8),

                              Container(
                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal:8,
                                  vertical:3,
                                ),
                                decoration:
                                BoxDecoration(
                                  color:
                                  Colors.black,
                                  borderRadius:
                                  BorderRadius.circular(12),
                                ),
                                child:
                                const Text(
                                  "L1,000",
                                  style:
                                  TextStyle(
                                    color:
                                    Colors.white,
                                    fontSize:
                                    10,
                                  ),
                                ),
                              )
                            ],
                          ),

                          const SizedBox(height:20),

                          Container(
                            width:160,
                            height:3,
                            color:
                            Colors.black,
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height:25),

                    Row(
                      children:[
                        Expanded(
                          child:
                          _actionButton(
                            Icons.archive,
                            "Archive",
                          ),
                        ),
                        const SizedBox(width:8),

                        Expanded(
                          child:
                          _actionButton(
                            Icons.add_task,
                            "Set up a loan",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height:30),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children:[
                        const Text(
                          "Loan name",
                          style:
                          TextStyle(
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        Row(
                          children:[
                            const Text(
                              "Payment plan",
                              style:
                              TextStyle(
                                fontSize:
                                12,
                              ),
                            ),

                            const SizedBox(width:5),

                            Icon(
                              Icons.chevron_right,
                              size:16,
                            )
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height:15),

                    Container(
                      width:
                      double.infinity,
                      padding:
                      const EdgeInsets.all(14),
                      decoration:
                      BoxDecoration(
                        color:
                        const Color(0xffF5F5F5),
                        borderRadius:
                        BorderRadius.circular(8),
                      ),
                      child:Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children:[
                          const Text(
                            "Left to pay",
                            style:
                            TextStyle(
                              color:
                              Colors.grey,
                              fontSize:
                              12,
                            ),
                          ),

                          const SizedBox(height:5),

                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children:[
                              const Text(
                                "L150",
                                style:
                                TextStyle(
                                  fontSize:
                                  28,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              Container(
                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal:8,
                                  vertical:3,
                                ),
                                decoration:
                                BoxDecoration(
                                  color:
                                  Colors.black,
                                  borderRadius:
                                  BorderRadius.circular(10),
                                ),
                                child:
                                const Text(
                                  "L200",
                                  style:
                                  TextStyle(
                                    color:
                                    Colors.white,
                                    fontSize:
                                    10,
                                  ),
                                ),
                              )
                            ],
                          ),

                          const SizedBox(height:10),

                          Stack(
                            children:[
                              Container(
                                height:4,
                                width:
                                double.infinity,
                                color:
                                Colors.grey.shade300,
                              ),
                              Container(
                                height:4,
                                width:
                                180,
                                color:
                                Colors.black,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height:30),

                    const Text(
                      "Upcoming payments",
                      style:
                      TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height:12),

                    _paymentPreview(
                      "2 of 4",
                      "Monday, February 02",
                      "Pay L50",
                    ),

                    _paymentPreview(
                      "3 of 4",
                      "Thursday, March 02",
                      "L50",
                    ),

                    _paymentPreview(
                      "4 of 4",
                      "Thursday, April 02",
                      "L50",
                    ),

                    _paymentPreview(
                      "1 of 4",
                      "Thursday, January 02",
                      "Paid",
                    ),

                    const SizedBox(height:20),

                    Center(
                      child: Container(
                        width:120,
                        height:10,
                        decoration:
                        BoxDecoration(
                          color:
                          Colors.grey.shade300,
                          borderRadius:
                          BorderRadius.circular(4),
                        ),
                      ),
                    ),

                    const SizedBox(height:30),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
      const AppBottomNavigation(
        currentIndex:2,
      ),
    );
  }

  Widget _actionButton(
      IconData icon,
      String text,
      ){
    return Container(
      height:38,
      decoration:
      BoxDecoration(
        color:
        const Color(0xffEEEEEE),
        borderRadius:
        BorderRadius.circular(6),
      ),
      child:Row(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children:[
          Icon(
            icon,
            size:15,
          ),

          const SizedBox(width:6),

          Text(
            text,
            style:
            const TextStyle(
              fontSize:12,
              fontWeight:
              FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  Widget _paymentPreview(
      String number,
      String date,
      String amount,
      ){
    final bool paid = amount == "Paid";

    return Container(
      margin:
      const EdgeInsets.only(
        bottom:8,
      ),
      padding:
      const EdgeInsets.all(10),
      decoration:
      BoxDecoration(
        color:
        const Color(0xffF5F5F5),
        borderRadius:
        BorderRadius.circular(5),
      ),

      child:Row(
        children:[
          Container(
            width:20,
            height:20,
            decoration:
            BoxDecoration(
              color:
              paid
                  ? Colors.grey.shade300
                  : Colors.grey.shade500,
              borderRadius:
              BorderRadius.circular(2),
            ),
          ),

          const SizedBox(width:10),

          Expanded(
            child:Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children:[
                Text(
                  number,
                  style:
                  const TextStyle(
                    fontWeight:
                    FontWeight.w600,
                    fontSize:
                    12,
                  ),
                ),
                Text(
                  date,
                  style:
                  const TextStyle(
                    color:
                    Colors.grey,
                    fontSize:
                    10,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal:8,
              vertical:4,
            ),
            decoration:
            BoxDecoration(
              color:
              paid
                  ? Colors.grey.shade300
                  : Colors.white,
              borderRadius:
              BorderRadius.circular(4),
            ),
            child:Text(
              amount,
              style:
              TextStyle(
                fontSize:
                11,
                fontWeight:
                FontWeight.w600,
                color:
                paid
                    ? Colors.grey
                    : Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}