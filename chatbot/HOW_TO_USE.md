# flutter-kit-features/chatbot — How to Use

## What's Inside

Generic AI chatbot with multi-turn sessions and local message caching:

```
chatbot/lib/
├── domain/
│   ├── entities/
│   │   ├── chat_message_entity.dart    ← sessionId, type, message, senderType, timestamp
│   │   └── chat_sender_type.dart       ← user | bot
│   ├── repositories/chatbot_repository.dart
│   └── usecases/
│       ├── send_message_params.dart    ← message + optional session ID
│       └── send_message_usecase.dart
├── data/
│   ├── datasources/
│   │   ├── chatbot_endpoints.dart      ← API path (TODO: set yours)
│   │   └── chatbot_remote_datasource.dart
│   ├── models/chat_message_model.dart  ← fromJson + toCacheJson
│   └── repositories/chatbot_repository_impl.dart
├── presentation/bloc/
│   ├── chat_bot_bloc.dart
│   ├── chat_bot_event.dart
│   └── chat_bot_state.dart
└── chatbot_injection.dart
```

---

## Setup

### 1. pubspec.yaml
```yaml
dependencies:
  flutter_bloc: ^9.0.0
  get_it: ^8.0.0
  fpdart: ^1.1.0
```

### 2. Configure endpoint
Edit `lib/data/datasources/chatbot_endpoints.dart`:
```dart
static const String sendMessage = '/chatbot/message';  // your endpoint
```

### 3. Configure initial prompt
Edit `chat_bot_bloc.dart`:
```dart
static const String initialPrompt = 'Hello, how can I help you?';
```

### 4. Register in DI
```dart
import 'features/chatbot/chatbot_injection.dart';

initChatBotInjection();
```

### 5. Provide bloc (requires userId for caching)
```dart
BlocProvider(
  create: (_) => sl.get<ChatBotBloc>(param1: userId)
    ..add(const LoadInitialChatEvent()),
  child: ChatBotScreen(),
)
```

---

## Usage

### Send a message
```dart
context.read<ChatBotBloc>().add(
  SendMessageEvent(SendMessageParams(message: 'What can you help me with?')),
);
```

### Display messages
```dart
BlocBuilder<ChatBotBloc, ChatBotState>(
  builder: (context, state) {
    return ListView.builder(
      reverse: true,
      itemCount: state.messages.length + (state.isTyping ? 1 : 0),
      itemBuilder: (_, i) {
        if (i == 0 && state.isTyping) return const TypingIndicator();
        final msg = state.messages[state.messages.length - (state.isTyping ? i : i + 1)];
        return MessageBubble(message: msg);
      },
    );
  },
)
```

### Clear chat
```dart
context.read<ChatBotBloc>().add(const ClearChatEvent());
```

---

## Tailored Fields Removed

| Removed | Reason |
|---------|--------|
| `ChatBotSuggestionEntity` | Wardrobe outfit suggestion (top/bottom/shoe/hat etc.) |
| `sentItems` / `pendingSuggestionItems` | Clothing items context in messages |
| `items` in `SendMessageParams` | Wardrobe items to send with message |
| `_latestSuggestionItems()` | Extracted wardrobe items from response |

---

## Backend Requirements

| Endpoint | Method | Description |
|----------|--------|-------------|
| `POST /chatbot/message` | POST | Send message, get bot response |

### Request body
```json
{
  "message": "What can you help me with?",
  "session": "optional-session-id-for-multi-turn"
}
```

### Response format (supports both single and array)
```json
[
  {
    "sessionId": "session-123",
    "type": "text",
    "message": "I can help you with...",
    "senderType": "bot",
    "timestamp": "2026-01-01T00:00:00.000Z"
  }
]
```
