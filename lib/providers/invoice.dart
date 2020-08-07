import 'package:ecodelivery/models/Invoice.dart';
import 'package:flutter/material.dart';

class InvoiceProvider with ChangeNotifier {
  Invoice _invoice;

  get invoice {
    return _invoice;
  }

  setinvoice(Invoice invoice) {
    _invoice = invoice;
    notifyListeners();
  }
}
