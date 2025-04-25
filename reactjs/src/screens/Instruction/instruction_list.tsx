
import ExtraItem from "../../components/extra_item/extra_item";
import React, {useContext, useEffect, useState} from "react";
import AuthContext from "../../context/auth_context";
import DataList from '../../components/data_list/data_list';
import { InstructionBloc } from "../../blocs/instruction_bloc";
import { InstructionModel } from "../../models/instruction_model";
import InstructionItem from "../../components/instruction_item/instruction_item";

function InstructionsList() {
    let {accessToken} = useContext(AuthContext);

    const fetchExtras = ()=>{
        return InstructionBloc(accessToken!);
    }
    return (
        <DataList
        fetchFunction={fetchExtras}
        renderItem={(item:InstructionModel)=><InstructionItem item={item}/>}
        title='اضافیجات'
              addLink='/instruction/add'
        />
    )
}

export default InstructionsList