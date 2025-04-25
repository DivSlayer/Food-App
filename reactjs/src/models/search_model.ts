import {ExtraModel} from "./extra_model";
import {InstructionModel} from "./instruction_model";
import {FoodModel} from "./food_model";
import {TransactionModel} from "./transaction_model";

interface props {
    instructions: InstructionModel[];
    extras: ExtraModel[];
    foods: FoodModel[];
    transactions: TransactionModel[];
}

export default class SearchModel {
    instructions: InstructionModel[];
    extras: ExtraModel[];
    foods: FoodModel[];
    transactions: TransactionModel[];


    constructor(props: props) {
        this.instructions = props.instructions ?? [];
        this.extras = props.extras ?? [];
        this.foods = props.foods ?? [];
        this.transactions = props.transactions ?? [];
    }

    static fromJson(json: any): SearchModel {
        let props: props = {
            instructions: Array.from((json.instructions as any[]).map(item => InstructionModel.fromJson(item))),
            extras: Array.from((json.extras as any[]).map(item => ExtraModel.fromJson(item))),
            foods: Array.from((json.foods as any[]).map(item => FoodModel.fromJson(item))),
            transactions: Array.from((json.transactions as any[]).map(item => TransactionModel.fromJson(item))),
        };
        return new SearchModel(
            props
        );
    }


}