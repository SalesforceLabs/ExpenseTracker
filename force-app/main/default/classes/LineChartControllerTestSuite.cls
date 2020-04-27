@isTest
public class LineChartControllerTestSuite {
	static testMethod void testGetTotalExpenseByMonth() {
        //Insert 3 Expenses totalling $2150.44 for this month
        Expense_Vendor__c vendor = new Expense_Vendor__c(Name='Test Vendor');
		insert vendor;

		Expense__c e1 = new Expense__c(Vendor__c=vendor.Id, Name='Expense 1', Expense_Approval_Status__c = 'Approved', Expense_Date__c=Date.today());
		insert e1;
		Expense_Item__c i1 = new Expense_Item__c(Expense__c=e1.Id, Name='Item 1', Expense_Item_Transaction_Date__c=Date.today(), Expense_Item_Category__c='Fees', Expense_Item_Amount__c=100.00);
		insert i1;
        
        Expense__c e2 = new Expense__c(Vendor__c=vendor.Id, Name='Expense 2', Expense_Approval_Status__c = 'Approved', Expense_Date__c=Date.today());
		insert e2;
		Expense_Item__c i2 = new Expense_Item__c(Expense__c=e2.Id, Name='Item 2', Expense_Item_Transaction_Date__c=Date.today(), Expense_Item_Category__c='Entertainment', Expense_Item_Amount__c=950.45);
		insert i2;
        
        Expense__c e3 = new Expense__c(Vendor__c=vendor.Id, Name='Expense 3', Expense_Approval_Status__c = 'Approved', Expense_Date__c=Date.today());
		insert e3;
		Expense_Item__c i3 = new Expense_Item__c(Expense__c=e3.Id, Name='Item 3', Expense_Item_Transaction_Date__c=Date.today(), Expense_Item_Category__c='Meetings and Events', Expense_Item_Amount__c=1099.99);
		insert i3;
        
        List<LineChartController.DataSet> result = LineChartController.getTotalExpenseByMonth();
        System.assertEquals(1, result.size(), 'There should only be 1 month worth of expenses in the result');
        System.assertEquals(Date.today().month(), result.get(0).month, 'Unexpected month');
        System.assertEquals(2150.44, result.get(0).totalAmount, 'Unexpected total amount');
    }
}