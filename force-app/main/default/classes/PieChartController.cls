public class PieChartController {   
    @AuraEnabled(cacheable=true)
    public static List<DataSet> getTotalExpenseByCategory(){
        List<AggregateResult> result =  [Select Expense_Item_Category__c category, sum(Amount__c) totalAmount from ExpenseItem__c GROUP BY Expense_Item_Category__c ORDER BY Expense_Item_Category__c];
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