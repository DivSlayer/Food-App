import PriceFormatter from "../../../utils/price_formatter";
import React, {useContext, useState} from "react";
import {SizeModel} from "../../../models/size_model";
import {useNavigate} from "react-router-dom";
import Links from "../../../utils/links";
import axios from "axios";
import Modal from "../../../components/modal/modal";
import AuthContext from "../../../context/auth_context";
import AddSizeModal from "./add_size_modal";

interface Props {
    size: SizeModel;
}

export function SizeItem({size}: Props) {
    const [showUpdateModal, setShowUpdateModal] = useState(false);
    const [showDelModal, setShowDelModal] = useState(false);
    const {accessToken = ''} = useContext(AuthContext);
    const history = useNavigate();

    const deleteHandle = async () => {
        try {
            const link: string = Links.sizeLink(size.uuid);
            const response = await axios.delete(link, {
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

    const handleUpdate = async ({name, price, details}: { name: string, price: string, details: string }) => {
        try {
            const link: string = Links.sizeLink(size.uuid);
            let formData = new FormData();
            let decoded_price = price.replaceAll(',', '');
            formData.append('price', decoded_price);
            formData.append('details', details);
            formData.append('name', name);


            const response = await axios.put(link, formData, {
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
        <>
            <li key={Math.random() * 100}>
                <div className="right">
                    <h2>{size.name}</h2><span>{size.details}</span>
                </div>
                <div className="middle">{PriceFormatter(size.price)} تومان</div>
                <div className="left">
                    <button className="btn yellow-btn" onClick={()=>setShowUpdateModal(true)}>ویرایش</button>
                    <button className="btn red-btn" onClick={() => setShowDelModal(true)}>حذف</button>
                </div>
            </li>
            <Modal show={showDelModal} handleClose={() => {
                setShowDelModal(false);
            }}>
                <h2>آیا از حذف کردن این سایز مطمئن اید؟</h2>
                <div className='row' style={{columnGap: "20px"}}>
                    <button className='btn red-btn' onClick={deleteHandle}>بله</button>
                    <button className='btn green-btn' onClick={() => setShowDelModal(false)}>خیر</button>
                </div>
            </Modal>


            <AddSizeModal setShowModal={setShowUpdateModal} showModal={showUpdateModal} handleAdd={handleUpdate}
                          modalTitle={"ویرایش سایز"}
                          defaultValues={
                              {
                                  "price": size.price,
                                  "name": size.name,
                                  "details":size.details,
                              }
                          }/>
        </>
    )
}
