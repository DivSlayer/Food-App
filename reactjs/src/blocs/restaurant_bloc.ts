import Links from "../utils/links";
import {RestaurantModel} from "../models/restaurant_model";

export async function RestaurantBloc(accessToken: string, uuid?: string | null): Promise<RestaurantModel | null> {
    const link: string = Links.restaurantLink;
    const response = await fetch(link, {
        method: 'GET',
        headers: {
            Authorization: `Bearer ${accessToken}`,
        },
    });
    if (response.ok) {
        let json_converted = await response.json();
        let transaction_json_list: { [key: string]: any };
        transaction_json_list = json_converted;
        return RestaurantModel.fromJson(json_converted);
    }
    return null;
}