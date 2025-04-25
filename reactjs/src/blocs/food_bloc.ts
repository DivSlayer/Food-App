import Links from "../utils/links";
import {FoodModel} from "../models/food_model";

export async function FoodBloc(accessToken: string, uuid?: string | null): Promise<FoodModel[] | null> {
    const link: string = Links.foodLink(uuid);
    const response = await fetch(link, {
        method: 'GET',
        headers: {
            Authorization: `Bearer ${accessToken}`,
        },
    });
    if (response.ok) {
        let json_converted = await response.json();
        let transaction_json_list: { [key: string]: any }[];
        transaction_json_list = json_converted['foods'];
        return transaction_json_list.map((item) => {
            return FoodModel.fromJson(item);
        });
    }
    return null;
}