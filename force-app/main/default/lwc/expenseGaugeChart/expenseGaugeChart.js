import { LightningElement } from 'lwc';

import { loadScript } from 'lightning/platformResourceLoader';
import chartjs from '@salesforce/resourceUrl/chart';

const generateRandomNumber = () => {
    return Math.round(Math.random() * 100);
};

export default class ExpenseGaugeChart extends LightningElement {
    error;
    chart;
    chartjsInitialized = false;

    config = {
        type: 'doughnut',
        data: {
            datasets: [
                {
                    data: [
                        75,25
                      ],
                    backgroundColor: [
                        'rgb(255, 99, 132)',
                        'rgb(201, 203, 207)'
                    ],
                    label: 'Budget'
                }
            ],
            labels: ['Spent Budget', 'Available Budget']
        },
        options: {
            responsive: true,
            rotation: 1.0 * Math.PI,
            legend: {
              display: false,
            },
            animation: {
                animateScale: true,
                animateRotate: true
            },
            circumference: Math.PI, 
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