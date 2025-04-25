import './category_Screen.scss'
import Loader from "../../components/loader/loader";
import React, {useContext, useEffect, useState} from "react";
import CategoryModel from "../../models/category_model";
import {CategoryBloc} from "../../blocs/category_bloc";
import AuthContext from "../../context/auth_context";
import CategoryItem from "./category_item";
import AddCategoryItem from "./add_category_item";
import Modal from "../../components/modal/modal";

export default function CategoryScreen() {
    const [isLoading, setIsLoading] = useState(true);
    const [isAdding, setIsAdding] = useState(false);
    const [categories, setCategories] = useState<CategoryModel[]>([]);

    let {accessToken} = useContext(AuthContext);

    useEffect(() => {
        fetchCategories();
    }, []);

    const fetchCategories = async () => {
        await CategoryBloc(accessToken!).then((data) => {

            if (data && data.length > 0) {
                setCategories(data);
            }
            setIsLoading(false);
        });
    }


    return (
        <>
            <div className='category_screen'>
                <div className='header'>
                    <h1>دسته بندی ها</h1>

                    {!isAdding ? <button className='btn green-btn' onClick={() => setIsAdding(true)}>اضافه کردن</button>
                        : <button className='btn red-btn' onClick={() => setIsAdding(false)}>لغو</button>}
                </div>
                {
                    isLoading ? <Loader/> : <ul>
                        {isAdding ? <AddCategoryItem onCancel={() => setIsAdding(false)} loadingAccess={setIsLoading}
                                                     refresh={fetchCategories}/> : <></>}
                        {categories.map((category) => <CategoryItem category={category} loadingAccess={setIsLoading}
                                                                    refresh={fetchCategories}/>)}
                    </ul>
                }

            </div>

        </>
    )
}