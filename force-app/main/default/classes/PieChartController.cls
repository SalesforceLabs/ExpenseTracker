public class PieChartController {   
    @AuraEnabled(cacheable=true)
    public static List<DataSet> getTotalExpenseByCategory(){
        Integer currentYear = Integer.valueOf(Date.today().year());
        List<AggregateResult> result =  [Select Expense_Item_Category__c category, sum(Expense_Item_Amount__c) totalAmount from Expense_Item__c WHERE calendar_year(Expense__R.Expense_Date__c) =: currentYear and Expense__R.Expense_Approval_Status__c = 'Approved' GROUP BY Expense_Item_Category__c ORDER BY sum(Expense_Item_Amount__c) DESC LIMIT 5]; 
        List<DataSet> dataSet = new List<DataSet>();
        for(AggregateResult ar:result){
            String category =  (String)ar.get('category') ;
            Decimal totalAmount =(Decimal)ar.get('totalAmount'); 
            dataSet.add(new DataSet(category ,totalAmount));
        }
        return dataSet ; 
    }
    
    public class DataSet{
        public DataSet(String category ,Decimal totalAmount){
            this.category  = category ; 
            this.totalAmount = totalAmount ;
        }
        @AuraEnabled
        public String category {get;set;}
        @AuraEnabled
        public Decimal totalAmount {get;set;}   
    }    
}