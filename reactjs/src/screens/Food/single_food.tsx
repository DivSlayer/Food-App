/*
File: src/pages/SingleFood.tsx
Main page tying everything together
*/
import React, {useContext, useState} from 'react';
import {useParams} from 'react-router-dom';
import AuthContext from "../../context/auth_context";
import {useFood} from '../../hooks/useFood';
import {useCategories} from "../../hooks/useCategories";
import Loader from "../../components/loader/loader";
import FoodForm from "./components/food_form";
import CustomToast from "../../components/toastify/toastify";
import DeleteModal from "./components/delete_modal";
import PhotoModal from "./components/photo_modal";
import EditIcon from "../../assets/svgs/create-outline.svg";


export default function SingleFood() {
    const {uuid = ''} = useParams();
    const {accessToken = ''} = useContext(AuthContext);
    const {food, loading, update, setFood} = useFood(uuid, accessToken!);
    const categories = useCategories(accessToken!);
    const [showDel, setShowDel] = useState(false);
    const [showPic, setShowPic] = useState(false);

    if (loading) return <Loader/>;
    if (!food) return <p>غذا یافت نشد</p>;

    const handleUpdate = (data: Record<string, any>) => update(data).then(() => CustomToast.success(), () => CustomToast.error());


    return (
        <div className="single-food">
            <div className="funcs">
                <button onClick={() => setShowDel(true)} className="btn red-btn">حذف</button>
            </div>
            <div className="details-holder">
                <div className="image" style={{backgroundImage: `url(${food.image})`}}>
                    <button onClick={() => setShowPic(true)} className="edit-btn">
                        <img src={EditIcon} alt='Edit'/>
                    </button>
                </div>
                <FoodForm data={food} setData={() => {
                }} categories={categories} onSubmit={handleUpdate}/>

            </div>

            <DeleteModal showModal={showDel} setShowModal={setShowDel} accessToken={accessToken} uuid={uuid}/>
            <PhotoModal
                showModal={showPic}
                uuid={uuid}
                setShowModal={setShowPic}
                accessToken={accessToken}
                setFood={setFood}
            />
            {CustomToast.container()}
        </div>
    );
}
