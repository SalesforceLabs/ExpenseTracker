public with sharing class PieChartController {
    @AuraEnabled(cacheable=true)
    public static List<DataSet> getTotalExpenseByCategory() {
        List<DataSet> dataSet = new List<DataSet>();

        if (checkAccess()) {
            Integer currentYear = Integer.valueOf(Date.today().year());
            List<AggregateResult> result =  [Select Expense_Item_Category__c category, sum(Expense_Item_Amount__c) totalAmount from Expense_Item__c WHERE calendar_year(Expense__R.Expense_Date__c) =: currentYear and Expense__R.Expense_Approval_Status__c = 'Approved' GROUP BY Expense_Item_Category__c ORDER BY sum(Expense_Item_Amount__c) DESC LIMIT 5];
            for(AggregateResult ar:result) {
                String category =  (String) ar.get('category');
                Decimal totalAmount =(Decimal) ar.get('totalAmount');
                dataSet.add(new DataSet(category ,totalAmount));
            }
        }

        return dataSet;
    }
    
    public class DataSet {
        public DataSet(String category ,Decimal totalAmount) {
            this.category  = category ; 
            this.totalAmount = totalAmount ;
        }
        @AuraEnabled
        public String category {get;set;}
        @AuraEnabled
        public Decimal totalAmount {get;set;}   
    }

    private static Boolean checkAccess() {
        if (!Expense_Item__c.SObjectType.getDescribe().isAccessible() ||
                !Expense__c.SObjectType.getDescribe().isAccessible()) {
            return false;
        }

        if (!Schema.sObjectType.Expense_Item__c.fields.Expense_Item_Category__c.isAccessible() ||
            !Schema.sObjectType.Expense_Item__c.fields.Expense_Item_Amount__c.isAccessible() ||
            !Schema.sObjectType.Expense__c.fields.Expense_Date__c.isAccessible() ||
            !Schema.sObjectType.Expense__c.fields.Expense_Approval_Status__c.isAccessible()) {
            return false;
        }

        return true;
    }
}