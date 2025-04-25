import './search.scss';
import FormGroup from "../../components/forms/form-group";
import {useContext, useState} from "react";
import {SearchBloc} from "../../blocs/search_bloc";
import AuthContext from "../../context/auth_context";
import SearchModel from "../../models/search_model";
import Loader from "../../components/loader/loader";
import FoodItem from "../../components/food_item/food_item";
import ExtrasItem from "../../components/extra_item/extra_item";
import InstructionItem from "../../components/instruction_item/instruction_item";
import TransactionItem from "../../components/transaction_item/transaction_item";

function Search() {
    const [value, setValue] = useState<string | null>();
    const [isLoading, setIsLoading] = useState<boolean>(false);
    const [searchResult, setSearchResult] = useState<SearchModel | null>(null);

    let {accessToken} = useContext(AuthContext);

    const searchValue = async () => {
        if (value != null) {
            setIsLoading(true);
            await SearchBloc(accessToken!, value).then(result => {
                setIsLoading(false);
                if (result != null) {
                    setSearchResult(result);
                }
                return result;
            });
        }
    }
    const SearchIcon = <svg xmlns="http://www.w3.org/2000/svg" className="ionicon" viewBox="0 0 512 512"
                            onClick={searchValue}>
        <path d="M221.09 64a157.09 157.09 0 10157.09 157.09A157.1 157.1 0 00221.09 64z" fill="none"
              stroke="currentColor" strokeMiterlimit="10" strokeWidth="32"/>
        <path fill="none" stroke="currentColor" strokeLinecap="round" strokeMiterlimit="10" strokeWidth="32"
              d="M338.29 338.29L448 448"/>
    </svg>;


    return (
        <div className='search'>

            <div className='search-input animate__animated animate__fadeInDown'>
                <FormGroup label='جستجو...' icon={SearchIcon} name='search'
                           value={value}
                           update={(e) => {
                               setValue(e);
                           }}
                />
            </div>
            <div className='result-section section animate__animated animate__fadeInUp'>
                <div className='section-header'>
                    <h3>نتایج</h3>
                </div>
                <div className='search-results'>
                    {isLoading ? <Loader/> : <ul className='result-items'>
                        {searchResult != null ? <>

                            {searchResult!.foods.length > 0 ? searchResult!.foods.map((item) => {
                                return <FoodItem item={item}/>
                            }) : <></>}
                            {searchResult!.extras.length > 0 ? searchResult!.extras.map((item) => {
                                return <ExtrasItem item={item}/>
                            }) : <></>}
                            {searchResult!.instructions.length > 0 ? searchResult!.instructions.map((item) => {
                                return <InstructionItem item={item}/>
                            }) : <></>}
                            {searchResult!.transactions.length > 0 ? searchResult!.transactions.map((item) => {
                                return <TransactionItem item={item}/>
                            }) : <></>}
                        </> : <></>}

                    </ul>}
                </div>
            </div>

        </div>
    )
}

export default Search;