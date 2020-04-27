@isTest
public class PieChartControllerTestSuite {
	static testMethod void testTotalExpenseByCategory() {
        //Insert 6 Expenses accross 3 categories
        Expense_Vendor__c vendor = new Expense_Vendor__c(Name='Test Vendor');
		insert vendor;

		Expense__c e1 = new Expense__c(Vendor__c=vendor.Id, Name='Expense 1', Expense_Approval_Status__c = 'Approved', Expense_Date__c=Date.today());
		insert e1;
        
        //Fees total $700.00, Entertainment total $1950.95, Meetings and Events Total $4199.98
		Expense_Item__c i1 = new Expense_Item__c(Expense__c=e1.Id, Name='Item 1', Expense_Item_Transaction_Date__c=Date.today(), Expense_Item_Category__c='Fees', Expense_Item_Amount__c=100.00);
		insert i1;
        Expense_Item__c i2 = new Expense_Item__c(Expense__c=e1.Id, Name='Item 2', Expense_Item_Transaction_Date__c=Date.today(), Expense_Item_Category__c='Entertainment', Expense_Item_Amount__c=950.45);
		insert i2;
		Expense_Item__c i3 = new Expense_Item__c(Expense__c=e1.Id, Name='Item 3', Expense_Item_Transaction_Date__c=Date.today(), Expense_Item_Category__c='Meetings and Events', Expense_Item_Amount__c=1099.99);
		insert i3;
        Expense_Item__c i4 = new Expense_Item__c(Expense__c=e1.Id, Name='Item 4', Expense_Item_Transaction_Date__c=Date.today(), Expense_Item_Category__c='Fees', Expense_Item_Amount__c=600.00);
		insert i4;
        Expense_Item__c i5 = new Expense_Item__c(Expense__c=e1.Id, Name='Item 5', Expense_Item_Transaction_Date__c=Date.today(), Expense_Item_Category__c='Entertainment', Expense_Item_Amount__c=1000.50);
		insert i5;
		Expense_Item__c i6 = new Expense_Item__c(Expense__c=e1.Id, Name='Item 6', Expense_Item_Transaction_Date__c=Date.today(), Expense_Item_Category__c='Meetings and Events', Expense_Item_Amount__c=3099.99);
		insert i6;
        
        List<PieChartController.DataSet> result = PieChartController.getTotalExpenseByCategory();
        System.assertEquals(3, result.size(), 'There should be 3 categories returned');
        for (PieChartController.DataSet cat : result) {
            if (cat.category == 'Fees') {
                System.assertEquals(700.00, cat.totalAmount, 'Unexpected Total Amount for Fees Category');
            } else if (cat.category == 'Entertainment') {
                System.assertEquals(1950.95, cat.totalAmount, 'Unexpected Total Amount for Entertainment Category');
            } else if (cat.category == 'Meetings and Events') {
                System.assertEquals(4199.98, cat.totalAmount, 'Unexpected Total Amount for Meetings and Events Category');
            } else {
                System.assert(false, 'Unexpected Category Name Found');
            }
        }
    }
}