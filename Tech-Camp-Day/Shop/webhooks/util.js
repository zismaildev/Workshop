function replier(client) {
    return function (event, ...messages) {
        return client.replyMessage({
            replyToken: event.replyToken,
            messages: messages.map(message => ({
                type: "text",
                text: message,
            })),
        });
    };
}

function pusher(client) {
    return function (userId, ...messages) {
        return client.pushMessage({
            to: userId,
            messages: messages.map(message => ({
                type: "text",
                text: message,
            })),
        });
    };
}


module.exports = {
    replier,
    pusher,
};
