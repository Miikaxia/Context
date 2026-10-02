const net = require("net");

const PORT = 5000;
const users = new Set();
const server_name = "Server";
const entrance_msg = "User connected, say hi!"

function message_send(fromSocket, DISPLAYNAME, message) {
    const text = `<${DISPLAYNAME}>: ${message}\n`;
    for (const user of users) {
        if (user !== fromSocket) {
            user.write(text);
        }
    }
}

const server = net.createServer((socket) => {
    console.log("User connected:", socket.remoteAddress, socket.remotePort);
    message_send("binglebongle", server_name, entrance_msg);
    users.add(socket);

    let buffer = "";

    socket.on("data", (data) => {
        buffer += data.toString("utf8");

        let newlineIndex;
        while ((newlineIndex = buffer.indexOf("\n")) !== -1) {
            const line = buffer.slice(0, newlineIndex).trim();
            buffer = buffer.slice(newlineIndex + 1);

            if (!line) continue;

            const sepIndex = line.indexOf("|");
            if (sepIndex === -1) {
                console.log("Malformed line from client:", line);
                continue;
            }

            const DISPLAYNAME =  line.slice(0, sepIndex);
            const message = line.slice(sepIndex + 1);

            console.log(DISPLAYNAME, 'sent', message);
            message_send(socket, DISPLAYNAME, message);
        }
    });

    socket.on("end", () => {
        console.log('User disconnected');
        message_send("binglebongle","Server", "User disconnected.");
        users.delete(socket);
    });
    
    socket.on("error", (err) => {
        console.log("Socket error: ", err.message);
        users.delete(socket);
    });
});

server.listen(PORT, () => {
    console.log('Chat opened on port ', PORT);
});