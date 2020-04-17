import { LightningElement, wire, track } from 'lwc';

import { loadScript } from 'lightning/platformResourceLoader';
import chartjs from '@salesforce/resourceUrl/chart';
import getTotalExpenseByCategory from '@salesforce/apex/PieChartController.getTotalExpenseByCategory';
export default class ExpensePieChart extends LightningElement {
    error;
    chart;
    @track data;
    category = [];
    totalAmountCategory = [];
    chartjsInitialized = false;

    @wire(getTotalExpenseByCategory) 
    getTotalExpenseCategory ({error, data}) {
        if (data) {
            this.data = data;
            for (let i = 0; i < this.data.length; i++){
                this.category.push(data[i].category);
                this.totalAmountCategory.push(data[i].totalAmount);   
            }
        }
        else if (error) {
            console.log(error);
            this.error = error;
        }
    };

    config = {
        type: 'doughnut',
        data: {
            datasets: [
                {
                    data: this.totalAmountCategory,
                    backgroundColor: [
                        'rgb(255, 99, 132)',
                        'rgb(255, 159, 64)',
                        'rgb(255, 205, 86)',
                        'rgb(75, 192, 192)',
                        'rgb(54, 162, 235)',
                        'rgb(153, 102, 255)',
                        'rgb(201, 203, 207)'
                    ],
                    label: 'Expenses by Category'
                }
            ],
            labels: this.category
        },
        options: {
            responsive: true,
            legend: {
                position: 'right'
            },
            animation: {
                animateScale: true,
                animateRotate: true
            }
        }
    };

    renderedCallback() {
        if (this.chartjsInitialized) {
            return;
        }
        this.chartjsInitialized = true;

        loadScript(this, chartjs)
            .then(() => {
                const canvas = document.createElement('canvas');
                this.template.querySelector('div.chart').appendChild(canvas);
                const ctx = canvas.getContext('2d');
                this.chart = new window.Chart(ctx, this.config);
            })
            .catch(error => {
                this.error = error;
            });
    }
}