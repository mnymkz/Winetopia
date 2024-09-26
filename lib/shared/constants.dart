import 'package:flutter/material.dart';

const textImportDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF00DEC3), width: 2.0),
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
  ),
);

const String stripePublishableKey =
    "pk_test_51PpNEkIMm5TYEIRdgj0CZHknQEqYTgyTau05XJNNaDeA2DkdSTsCJQqSFliKGM2ObTqdHX837HXlosFGTyVArbS8009pjBOB7G";
const String stripeSecretKey = "";
