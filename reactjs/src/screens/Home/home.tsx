import './_home.scss';
import TransactionSection from "./components/transaction_section";
import StarIcon from '../../assets/svgs/star.svg';
// Foods
import Pizza from '../../assets/vectors/pizza.svg';
import Cake from '../../assets/vectors/cake.svg';
import Cheese from '../../assets/vectors/cheese.svg';
import Fries from '../../assets/vectors/fries.svg';
import Hamburger from '../../assets/vectors/hamburger.svg';
import Mushrooms from '../../assets/vectors/mushrooms.svg';
import React from "react";
import FoodSection from "./components/food_section";
import ExtrasSection from './components/extras_section';
import InstructionsSection from './components/instruction_section';

const Home = () => {
    return (<div className='content home animate__animated animate__fadeInDown'>
        <h1 className='header-title'>غذای فوری در همه جا</h1>
        <TransactionSection/>
        <FoodSection/>
        <ExtrasSection/>
        <InstructionsSection/>
    </div>)
}

export default Home;