<table border="0" class="ctable" cellpadding="2" cellspacing="0">

    <tr style="font-size:larger; font-weight: bolder;">
        <td align="center" colspan="2">
            Отчет по начислениям  и удержаниям
        </td>
    </tr>
    <tr>

        <td align="center" colspan="2">
            Период с {{mfrom}} {{yfrom}} по {{mto}} {{yto}}
        </td>
    </tr>
    {{#isemp}}
    <tr>

        <td style="font-weight: bolder;" colspan="2">
            {{emp_name}}
        </td>
    </tr>
    {{/isemp}}

    {{#_detail}}
    <tr>

        <td>{{k}}</td>
        <td class="text-right">{{v}}</td>

    </tr>
    {{/_detail}}
  

</table>

