import { LightningElement, track, wire } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import chartjs from '@salesforce/resourceUrl/chart';
import getTotalExpenseByMonth from '@salesforce/apex/LineChartController.getTotalExpenseByMonth';

const chartColors = {
	red: 'rgb(255, 99, 132)',
	orange: 'rgb(255, 159, 64)',
	yellow: 'rgb(255, 205, 86)',
	green: 'rgb(75, 192, 192)',
	blue: 'rgb(54, 162, 235)',
	purple: 'rgb(153, 102, 255)',
	grey: 'rgb(201, 203, 207)'
};

const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']

export default class ExpenseLineChart extends LightningElement {
    error;
    chart;
    @track data;
    month = [];
    totalAmountMonth = [];
    chartjsInitialized = false;
    @wire(getTotalExpenseByMonth) 
    getTotalExpenseMonth ({error, data}) {
        if (data) {
            this.data = data;
            for (let i = 0; i < this.data.length; i++){
                this.month.push(months[data[i].month-1]);
                this.totalAmountMonth.push(data[i].totalAmount);   
            }
        }
        else if (error) {
            console.log(error);
            this.error = error;
        }

        //Load chart if not loaded
        if (!this.chartjsInitialized && (data || error)) {
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
    };

    config = {
        type: 'line',
        data: {
            labels: this.month,
            datasets: [{
                label: 'Expenses by month',
                backgroundColor: 'rgba(54, 162, 235, 0.2)',
                borderColor: chartColors.blue,
                data: this.totalAmountMonth,
                fill: true,
            }]
        },
        options: {
            legend: {
                display: false
            },
            responsive: true,
            title: {
                display: true,
                text: 'Expenses Line Chart'
            },
            tooltips: {
                mode: 'index',
                intersect: false,
            },
            hover: {
                mode: 'nearest',
                intersect: true
            },
            scales: {
                x: {
                    display: true,
                    scaleLabel: {
                        display: true,
                        labelString: 'Month'
                    }
                },
                y: {
                    display: true,
                    scaleLabel: {
                        display: true,
                        labelString: 'Total Expense'
                    }
                }
            }
        }
    };
}