int calcResult(int? contentNum, double rate){
  double resultNum = 0;
  if(contentNum != null && contentNum < 999999){
    resultNum = (contentNum - 250) * 100 * rate;
    return resultNum.round();
  }else{
    return 999999;
  }
}

String toResultString(int calcResult){
  String result = calcResult.toString();
  if(calcResult == 999999){
    result = "";
  }else if(calcResult > 0){
    result = "+" + result;
  }
  return result;
}

int totalPoints(List items){
    int total = 0;
    items.forEach((e) => e.isInput == true ? total += e.contentNum as int : total);
    return total;
  }

  int resultPoint(double rate, List items, int count){
    int total = totalPoints(items);
    int inputTotalCount = count;
    double result = (total - 250 * inputTotalCount) * 100 * rate;
    return result.round();
  }

  String totalResult(double p,List items, int count){
    int total = resultPoint(p,items,count);
    String totalResult = total.toString();
    if(total > 0){
      totalResult = '+' + totalResult;
    }
    return totalResult;
  }

  int inputTotalCount(List items,int count){
    count = 0;
    items.forEach((e) => e.isInput == true ? count++ : count);
    return count;
  }

  