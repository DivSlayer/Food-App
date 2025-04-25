import { InstructionModel } from "../models/instruction_model";
import Links from "../utils/links";

export async function InstructionBloc(accessToken: string, uuid?: string | null): Promise<InstructionModel[] | null> {
    const link: string = Links.instructionLink(uuid);
    const response = await fetch(link, {
        method: 'GET',
        headers: {
            Authorization: `Bearer ${accessToken}`,
        },
    });
    if (response.ok) {
        let json_converted = await response.json();
        let transaction_json_list: { [key: string]: any }[];
        transaction_json_list = json_converted['instructions'];
        return transaction_json_list.map((item) => {
            return InstructionModel.fromJson(item);
        });
    }
    return null;
}