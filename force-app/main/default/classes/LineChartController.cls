public class LineChartController {   
    @AuraEnabled(cacheable=true)
    public static List<DataSet> getTotalExpenseByMonth(){
        Integer currentYear = Integer.valueOf(Date.today().year());
        List<AggregateResult> result =  [Select calendar_month(Expense_Date__c) month, sum(Expense_Total_Amount__c) totalAmount from Expense__c WHERE calendar_year(Expense_Date__c) =: currentYear and Expense_Approval_Status__c = 'Approved' GROUP BY calendar_month(Expense_Date__c) ORDER BY calendar_month(Expense_Date__c) ASC ];
        List<DataSet> dataSet = new List<DataSet>();
        for(AggregateResult ar:result){
            Integer month =  (Integer)ar.get('month');
            Decimal totalAmount =(Decimal)ar.get('totalAmount'); 
            dataSet.add(new DataSet(month ,totalAmount));
        }
        return dataSet ; 
    }
    
    public class DataSet{
        public DataSet(Integer month ,Decimal totalAmount){
            this.month  = month ; 
            this.totalAmount = totalAmount ;
        }
        @AuraEnabled
        public Integer month {get;set;}
        @AuraEnabled
        public Decimal totalAmount {get;set;}   
    }    
}