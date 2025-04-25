import './food_list.scss'
import FoodItem from "../../components/food_item/food_item";
import React, {useContext, useEffect, useState} from "react";
import {FoodModel} from "../../models/food_model";
import AuthContext from "../../context/auth_context";
import Loader from "../../components/loader/loader";
import {FoodBloc} from "../../blocs/food_bloc";
import DataList from '../../components/data_list/data_list';

function FoodList() {
    let {accessToken} = useContext(AuthContext);

    const fetchFoods = async ()=> {
       return FoodBloc(accessToken!);
    }
    return (
        <DataList
        fetchFunction={fetchFoods}
        renderItem={(item:FoodModel)=><FoodItem item={item}/>}
        title='غذا ها'
        addLink='/food/add'
        
        />
    )
}
export default FoodList