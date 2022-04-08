<?php

namespace App\Entity;

/**
 * Класс-сущность  товар  поставщика
 *
 * @table=supitems
 * @view=supitems_view
 * @keyfield=supitem_id
 */
class CustItem extends \ZCL\DB\Entity
{

 

    protected function init() {
        $this->custitem_id = 0;
    
    }

 

    protected function afterLoad() {
        //распаковываем  данные из item detail
        $xml = simplexml_load_string($this->detail);
        $this->itemprice = (string)($xml->price1[0]);

   
        parent::afterLoad();
    }

 
   
}