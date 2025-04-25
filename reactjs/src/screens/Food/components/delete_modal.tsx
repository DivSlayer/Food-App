import React from "react";
import Modal from "../../../components/modal/modal";
import Links from "../../../utils/links";
import axios from "axios";
import {useNavigate} from "react-router-dom";

interface Props {
    showModal: boolean;
    setShowModal: (value: React.SetStateAction<boolean>) => void;
    accessToken: string | null;
    uuid: string | null;
}

export default function DeleteModal({showModal, setShowModal, accessToken, uuid}: Props) {
    const history = useNavigate();

    const deleteHandle = async () => {
        try {
            const link: string = Links.foodLink(uuid);
            const response = await axios.delete(link, {
                headers: {
                    'Content-Type': 'multipart/form-data',
                    Authorization: `Bearer ${accessToken}`,
                },
            });
            if (response.status === 200) {
                history('/food-list');
            }
        } catch (error) {
            console.error('Error deleting file:', error);
        }

    };

    return (
        <>
            {/*Delete Modal*/}
            <Modal show={showModal} handleClose={() => {
                setShowModal(false);
            }}>
                <h2>آیا از حذف کردن این غذا مطمئن اید؟</h2>
                <div className='row' style={{columnGap: "20px"}}>
                    <button className='btn red-btn' onClick={deleteHandle}>بله</button>
                    <button className='btn green-btn' onClick={() => setShowModal(false)}>خیر</button>
                </div>
            </Modal>
        </>
    )
}