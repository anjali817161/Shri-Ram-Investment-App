import 'package:get/get.dart';
import 'package:shreeram_investment_app/modules/bonds/model/bonds_model.dart';

class BondsController extends GetxController {
  RxList<BondModel> bonds = <BondModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBonds();
  }

  void loadBonds() {
    bonds.value = [
      BondModel(
        name: 'Progfin Oct\'25',
        month: 'Oct\'25',
        rate: 12,
        oldRate: 11.75,
        soldPercent: 98,
        minAmount: '₹10k',
        tenure: '3–14 months',
        tag: 'High Returns',
      ),
      BondModel(
        name: 'U GRO-3 Aug\'25',
        month: 'Aug\'25',
        rate: 11.5,
        oldRate: 11.25,
        soldPercent: 97,
        minAmount: '₹1k',
        tenure: '3–17 months',
        tag: '',
      ),
      BondModel(
        name: 'Progfin-2 Sep\'25',
        month: 'Sep\'25',
        rate: 12,
        oldRate: 11.75,
        soldPercent: 90,
        minAmount: '₹10k',
        tenure: '3–11 months',
        tag: '',
      ),
      BondModel(
        name: 'Muthoottu Mini Gold Oct\'25',
        month: 'Oct\'25',
        rate: 11.25,
        oldRate: 11,
        soldPercent: 70,
        minAmount: '₹1k',
        tenure: '3–12 months',
        tag: 'Lowest Tenure',
      ),
    ];
  }
}
