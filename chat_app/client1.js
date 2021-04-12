const socket = io('http://localhost:3000');

const form = document.getElementById('send-container');
const messageInput = document.getElementById('messageInp');
const messageContainer = document.querySelector('.container');

//var audio = new Audio('ting.mp3');
/*do {
    name = prompt('Enter your name to join the chat');
} while (!name)*/


const user_id = (Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15)).toUpperCase();
const user_name = 'User-' + Math.floor(Math.random() * 11);
const user_detail = {
    user_id: user_id,
    user_name: user_name,
};

const append = (message, position) => {
    const messageElement = document.createElement('div');
    messageElement.innerHTML = message;
    messageElement.classList.add('message');
    messageElement.classList.add(position);
    messageContainer.append(messageElement);
    scrollToBottom();
    /*if (position == 'left') {
        audio.play();
    }*/
};

form.addEventListener('submit', async(e) => {
    e.preventDefault();
    const files = document.querySelector('input[type=file]').files;
    var file_count = files.length;
    var photo = '';
    if (file_count > 0) {
        var file = files[0];
        let contentBuffer = await readFileAsync(file);
        photo = contentBuffer;
    }

    var params = {};
    var message = messageInput.value;
    params.message = message;
    params.photo = photo;
    if (photo != '') {
        message += '<img src="' + photo + '" style="max-width: 100%" />';
    }
    append('You ' + message, 'right');
    socket.emit('send', params);
    messageInput.value = '';
    document.getElementById('file').value = '';
});

function readFileAsync(file) {
    return new Promise((resolve, reject) => {
        let reader = new FileReader();
        reader.onload = (evt) => {
            resolve(evt.target.result);
        };
        reader.readAsDataURL(file);
    })
}

socket.emit('new-user-joined', user_detail);

socket.on('user-joined', name => {
    append(name + ' join the chat', 'right');
});

socket.on('console.log', data => {
    alert("asdfsd")
    console.log(data)
});



socket.on('receive', data => {
    var msg = data.name + ': ' + data.message;
    if (data.photo != '') {
        msg += '<img src="' + data.photo + '" style="max-width: 100%" />';
    }
    append(msg, 'left');
});

socket.on('disconnect', name => {
    append(name + ' left the chat', 'right');
});

function scrollToBottom() {
    messageContainer.scrollTop = messageContainer.scrollHeight;
}