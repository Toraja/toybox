$(document).ready(function(){
	var totColNum = 4;
	var totRowNum = 3;
	var TH1 = "<th><img src=\"images/minus.png\" alt=\"Delete\" class=\"deleteCol\" width=\"22\" height=\"22\"><img src=\"images/plus.png\" alt=\"Insert\" class=\"insertCol\" width=\"22\" height=\"22\"><input type=\"checkbox\" class=\"qt\"></th>";
	var TH2 = "<th><input type=\"text\" class=\"header\"></th>";
	var TD = "<td><input type=\"text\"></td>";
	var quote = "'";
	var quoteAll = false;
	
	// for test
	var DEBUG = false; 
	
	function init2DArray(row, col){
		var array = new Array(row);
		for(i = 0; i < row; i++){
			array[i] = new Array(col);
		} 
		return array;
	}

	// this function is called when inserting a row
	function createRow(){
		var row = "<tr><td><img src=\"images/clear.png\" alt=\"Clear\" class=\"clear\" width=\"22\" height=\"22\"><img src=\"images/minus.png\" alt=\"Delete\" class=\"deleteRow\" width=\"22\" height=\"22\"><img src=\"images/plus.png\" alt=\"Insert\" class=\"insertRow\" width=\"22\" height=\"22\"></td>";
		for (var i = 0; i < totColNum; i++){
			row += TD;
		}
		row += "</tr>"
		return row;
	}

	// initiating a table of the default size 
	function initTable(){
		var thead = "<tr><th></th>";
		for (var i = 0; i < totColNum; i++){
			thead += TH1;
		}
		thead += "</tr><tr><th id=\"headerTitle\"><img src=\"images/clear.png\" alt=\"Clear\" class=\"clear\" width=\"22\" height=\"22\">Title:</th>";
		for (var i = 0; i < totColNum; i++){
			thead += TH2;
		}
		thead += "</tr>";
		$('thead').append(thead);
		for (var j = 0; j < totRowNum; j++){
			$('tbody').append(createRow());
		}
	}
	
	// toggle quoteAll variable when "Quote All" checkbox is checked/unchecked
	$('#qtAll').click(function(){
		quoteAll = !quoteAll;
		if(quoteAll){
			$('.qt').prop('checked', true);
		}
		else {
			$('.qt').prop('checked', false);
		}
	});
	
	// uncheck "Quote All" when individual checkbox is clicked
	$('thead').on('click', '.qt', function(){
		if(quoteAll){
			quoteAll = !quoteAll;
			$('#qtAll').prop('checked', false);
		}
	});
	
	// set quote variable to single quotation
	$('#single').click(function(){
		quote = "'";
	});
	// set quote variable to double quotation
	$('#double').click(function(){
		quote = "\"";
	});
	
	// when "Add Row" button is clicked
	$('#addRow').click(function(){
		$('tbody').append(createRow());
		totRowNum++;
	});
	
	// when "Add Column" button is clicked
	$('#addCol').click(function(){
		$("thead tr:nth-child(1)").append(TH1);
		$("thead tr:nth-child(2)").append(TH2);
		$("tbody tr").append(TD);
		totColNum++;
	});
	
	// when "-" button at the top is clicked
	$('thead').on("click", ".deleteCol", function(){
		if(totColNum > 1){
			var thisColIdx = $(this).parent().index() + 1;
			$(this).parent().remove();
			$("thead tr:nth-child(2) th:nth-child(" + thisColIdx + ")").remove();
			$("tbody tr td:nth-child(" + thisColIdx + ")").remove();
			totColNum--;
		}
	});
	// when "+" button at the top is clicked
	$('thead').on("click", ".insertCol", function(){
		var thisColIdx = $(this).parent().index();
		$(this).parent().before(TH1);
		$("thead tr:nth-child(2) th:nth-child(" + thisColIdx + ")").after(TH2);
		$("tbody tr td:nth-child(" + thisColIdx + ")").after(TD);
		totColNum++;
	});
	
	// when eraser button is clicked
	$('table').on("click", ".clear", function(){
		$(this).parent().siblings().children().val("");
	});
	// when "-" button at the left is clicked
	$('tbody').on("click", ".deleteRow", function(){
		if(totRowNum > 1){
			$(this).closest('tr').remove();
			totRowNum--;
		}
	});
	// when "+" button at the left is clicked
	$('tbody').on("click", ".insertRow", function(){
		$(this).closest('tr').before(createRow());
		totRowNum++;
	});

	// output csv when "Create CSV" button is clicked
	$('#createCSV').click(function(){
		$('textarea').val("");
		var rowToOutput = "";
		var rowToOutputArray = init2DArray(totRowNum, totColNum);
		var qtColIndex = new Array();

		for (var i = 1; i <= totRowNum; i++){
			for (var j = 2; j <= (totColNum + 1); j++){
				rowToOutputArray[i-1][j-2] = $("tbody tr:nth-child(" + i + ") td:nth-child(" + j + ") input").val();
			}
		}

		$('input:checkbox:checked.qt').each(function(){
			qtColIndex.push($(this).parent().index());
		});
		if(qtColIndex.length > 0){
			for (var i = 0; i < qtColIndex.length; i++){
				for (var j = 0; j < rowToOutputArray.length; j++){
					rowToOutputArray[j][qtColIndex[i]-1] = quote + rowToOutputArray[j][qtColIndex[i]-1] + quote;
				}
			}
		}

		for (var i = 0; i < rowToOutputArray.length; i++){
			if($('#parentheses').is(':checked')){
				rowToOutput += "(" + rowToOutputArray[i].toString() + ")\n";
			} else{
				rowToOutput += rowToOutputArray[i].toString() + "\n";
			}
		}
		
		$('textarea').val(rowToOutput);
	});
	
	initTable();
	
	// for test
	if(DEBUG){
		var b = 0;
		function addInput(){
			$('input:text').each(function(){
				if($(this).val().length == 0){
					$(this).val(b++);
				}
			});
		}
		
		$('thead').on("click", ".insertCol", addInput);
		$('tbody').on("click", ".insertRow", addInput);
		$('#addRow').click(addInput);
		$('#addCol').click(addInput);

		addInput();
	}
	
});