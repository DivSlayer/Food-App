import './extra_list.scss';
import ExtraItem from "../../components/extra_item/extra_item";
import React, {useContext, useEffect, useState} from "react";
import {ExtraModel} from "../../models/extra_model";
import AuthContext from "../../context/auth_context";
import Loader from "../../components/loader/loader";
import { ExtrasBloc } from '../../blocs/extra_bloc';
import DataList from '../../components/data_list/data_list';

function ExtraList() {
    let {accessToken} = useContext(AuthContext);

    const fetchExtras = ()=>{
        return ExtrasBloc(accessToken!);
    }
    return (
        <DataList
        fetchFunction={fetchExtras}
        renderItem={(item:ExtraModel)=><ExtraItem item={item}/>}
        title='مخلفات'
              addLink='/extra/add'
        />
    )
}

export default ExtraList