$(document).ready(function() {
    // write the base url on which the socket is running
    const socket = io('http://localhost:3000');
    $('.chat-box-main').hide();
    $('.join-room-button').click(function() {
        if ($('#room-name').val().length > 0) {
            window.room_id = $('#room-name').val();
            socket.emit('join_room', {
                room_id: $('#room-name').val()
            })

            $('.chat-box-main').show();
            $('.join-room-main').hide();

        } else {
            alert('Please enter the room name')
        }
    })

    window.target_id = "";
    window.token = "";
    // when client first time open the page
    // when it start register to this chat app 
    $('.let-me-chat').click(function() {
        window.token = document.getElementById('token').value;
        window.target_id = document.getElementById('target_id').value;
        if (window.token && window.target_id) {
            $('.enter-token').hide();
            $('.enter-target').hide();
        } else {
            alert('Please enter the detail')
        }

    });


    socket.on('error_message', function(data) {
        alert('Message could not send as there is some error ' + data.message)
        $('.chat-box-main').hide()
    })

    socket.on('error_message_token_expire', function(data) {
        alert('Token is expire please login again')

    })

    $('.send-button').click(function() {
        if (window.target_id == "") {
            $('#msg_for_user').html("Please enter the target id to enter the chat");
            setTimeout(() => {
                $('#msg_for_user').html('')
            }, 3000);
        } else {
            text_msg = document.getElementById("text-msg").value;

            $('.msg-area').append(`<div class="msg-section my-1">\
            <h5>${text_msg}</h5>\
            <h6 class="float-right">@You</h6>\ 
            </div>`);

            document.getElementById("text-msg").value = "";
            $('.msg-area').scrollTop($('.msg-area')[0].scrollHeight);

            $('.msg-area').scrollTop($('.msg-area')[0].scrollHeight);
            // add the token in the source_token
            socket.emit('client_msg', {
                new_client_msg: text_msg,
                room_id: window.room_id,
                target_id: window.target_id,
                token: window.token
            });
        }
    })

    socket.on('client_msg_server_to_client', function(data) {
        // for couple talk
        // if (data.client_name != window.client_name) {
        //     $('.msg-area').append(`<h5 class="text-left">${data.msg_client}</h5>`);
        //     $('.msg-area').scrollTop($('.msg-area')[0].scrollHeight);
        // }
        $('.msg-area').append(`<div class="msg-section my-1">\
            <h5>${data.msg_client}</h5>\
            <h6 class="float-right">@Other</h6>\ 
            </div>`);
        $('.msg-area').scrollTop($('.msg-area')[0].scrollHeight);
    })

    $(document).keypress(function(e) {
        if (e.keyCode == 13) {
            $('.send-button').click();
        }
    })
})