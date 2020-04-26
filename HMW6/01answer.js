d3.csv('https://https://raw.githubusercontent.com/omerozeren/DATA608/master/HMW6/ue_industry.csv', data => {

    // Define your scales and generator here.

console.log(data);

const xScale = d3.scaleLinear()
	.domain(d3.extent(data, d => +d.index))
	.range([1180, 20]);

const yScale = d3.scaleLinear()
	.domain(d3.extent(data, d => +d.Agriculture))
	.range([580, 20]);

var line = d3.line()
	.x(d => xScale(+d.index))
	.y(d => yScale(+d.Agriculture));

d3.select('#answer1')
   // append more elements here
   .append('path')
   .attr('d', line(data))
   .attr('stroke', '#2e2928');

});
