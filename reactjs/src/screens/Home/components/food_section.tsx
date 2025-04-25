import './food_section.scss';
import React, {useContext, useEffect, useState} from "react";
import Pizza from "../../../assets/vectors/pizza.svg";
import Cake from "../../../assets/vectors/cake.svg";
import Cheese from "../../../assets/vectors/cheese.svg";
import Fries from "../../../assets/vectors/fries.svg";
import Hamburger from "../../../assets/vectors/hamburger.svg";
import Mushrooms from "../../../assets/vectors/mushrooms.svg";
import FoodItem from "../../../components/food_item/food_item";
import {Link} from "react-router-dom";
import AuthContext from "../../../context/auth_context";
import {FoodModel} from "../../../models/food_model";
import Loader from "../../../components/loader/loader";
import {TransactionModel} from "../../../models/transaction_model";
import Links from "../../../utils/links";
import {FoodBloc} from "../../../blocs/food_bloc";

const FoodSection = () => {
    const [isLoading, setIsLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [foods, setFoods] = useState<FoodModel[]>([]);
    let {accessToken} = useContext(AuthContext);

    useEffect(() => {
        fetchFoods();
    }, []);

    const fetchFoods = async () => {
        let foodRetrieval: FoodModel[] | null = await FoodBloc(accessToken ?? "").then(item => {
            setIsLoading(false);
            if (!item) {
                setError('خطایی رخ داده است');
            }
            return item;
        });
        setFoods(foodRetrieval ?? []);
    }
    return (
        <div className='section food-section mt-3'>
            <div className='section-header'>
                <h3>غذا ها</h3>
                <Link to='/food/list'>دیدن همه</Link>
            </div>
            {isLoading || error !== null ? <div className='loading-sec'>
                {isLoading ? <Loader/> : <></>}
                {isLoading ? <p>درحال دریافت اطلاعات ...</p> : error ? <p>{error}</p> : <></>}
            </div> : <></>}
            <ul className='section-items'>
                {foods.slice(0, 7).map((item) => {
                    return <FoodItem item={item}/>
                })}
            </ul>
        </div>
    )
}

export default FoodSection;