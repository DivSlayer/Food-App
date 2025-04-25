/*
File: src/components/SizesList.tsx
Displays list of sizes with edit/delete buttons
*/
import React, {useContext, useState} from 'react';
import {SizeModel} from "../../../models/size_model";
import {SizeItem} from "./size_item";
import AddIcon from '../../../assets/svgs/add-outline.svg';
import Modal from "../../../components/modal/modal";
import FormGroup from "../../../components/forms/form-group";
import PriceFormatter from "../../../utils/price_formatter";
import Links from "../../../utils/links";
import axios from "axios";
import AuthContext from "../../../context/auth_context";
import AddSizeModal from "./add_size_modal";


interface Props {
    sizes: SizeModel[];
    foodUUID: string;
}

export default function SizesList({sizes, foodUUID}: Props) {

    const [showAddModal, setShowAddModal] = React.useState(false);
    const {accessToken = ''} = useContext(AuthContext);

    const handleAdd = async ({name, price, details}: { name: string, price: string, details: string, }) => {
        try {
            const link: string = Links.sizeLink(foodUUID);
            let formData = new FormData();
            let decoded_price = price.replaceAll(',', '');
            formData.append('price', decoded_price);
            formData.append('details', details);
            formData.append('name', name);


            const response = await axios.post(link, formData, {
                headers: {
                    'Content-Type': 'multipart/form-data',
                    Authorization: `Bearer ${accessToken}`,
                },
            });
            if (response.status === 200) {
                window.location.reload();
            }
        } catch (error) {
            console.error('Error deleting file:', error);
        }
    }

    return (
        <div className="sizes">
            <div className='topping'>
                <span className="label">سایز ها</span>
                <span className="add-btn" onClick={() => setShowAddModal(true)}>
                <img src={AddIcon} alt='Add Size'/>
            </span>
            </div>

            <ul className="sizes-holder">
                {sizes.map(s => (
                    <SizeItem size={s}/>
                ))}
            </ul>
            <AddSizeModal setShowModal={setShowAddModal} showModal={showAddModal} handleAdd={handleAdd} defaultValues={{}}/>
        </div>
    );
}

