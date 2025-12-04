# Implementation Guide - Pawkar App Improvements

## Quick Start

All the improvements are ready to use. Here's how to integrate them into your screens:

### 1. Using EventService for API Calls

```dart
import 'package:pawkar_app/services/event_service.dart';

final eventService = EventService();

// Get featured events
final featured = await eventService.getFeaturedEvents();

// Get upcoming events
final upcoming = await eventService.getUpcomingEvents(limit: 10);

// Get events by category
final sports = await eventService.getEventsByCategory('Fútbol');

// Search events
final results = await eventService.searchEvents('Concert');
```

### 2. Using Network State Providers

```dart
import 'package:pawkar_app/providers/network_state_provider.dart';

class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  late final NetworkListStateProvider<Event> _eventsProvider;
  final EventService _eventService = EventService();

  @override
  void initState() {
    super.initState();
    _eventsProvider = NetworkListStateProvider<Event>();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    // This automatically manages loading, success, and error states
    await _eventsProvider.executeAsync(
      () => _eventService.getFeaturedEvents(),
      onSuccess: () {
        print('Events loaded successfully');
      },
      onError: (error) {
        print('Error: $error');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check state and display appropriate UI
    if (_eventsProvider.isLoading) {
      return const LoadingWidget(message: 'Loading events...');
    }

    if (_eventsProvider.isError) {
      return NetworkErrorWidget(
        error: _eventsProvider.error,
        onRetry: _loadEvents,
      );
    }

    if (_eventsProvider.data == null || _eventsProvider.data!.isEmpty) {
      return EmptyStateWidget(
        title: 'No Events',
        message: 'There are no events available',
      );
    }

    // Display the data
    return ListView(
      children: _eventsProvider.data!
          .map((event) => EventCard(event: event))
          .toList(),
    );
  }

  @override
  void dispose() {
    _eventsProvider.dispose();
    super.dispose();
  }
}
```

### 3. Using Loading Widgets

```dart
// Simple loading indicator
LoadingWidget(
  message: 'Loading...',
  size: 50,
  color: Theme.of(context).colorScheme.primary,
)

// Skeleton loading for lists
LoadingListWidget(
  itemCount: 5,
  height: 100,
)
```

### 4. Using Error Widgets

```dart
// Generic error widget
ErrorWidget(
  title: 'Oops!',
  message: 'Something went wrong',
  actionLabel: 'Retry',
  onRetry: () => _reload(),
)

// Empty state
EmptyStateWidget(
  title: 'No Results',
  message: 'Try adjusting your filters',
  icon: Icons.inbox_outlined,
)

// Network-specific error (auto-detects error type)
NetworkErrorWidget(
  error: 'Connection timeout',
  message: 'The request took too long. Please try again.',
  onRetry: _retry,
)
```

### 5. Complete Screen Example

```dart
import 'package:flutter/material.dart';
import 'package:pawkar_app/models/event.dart';
import 'package:pawkar_app/providers/network_state_provider.dart';
import 'package:pawkar_app/services/event_service.dart';
import 'package:pawkar_app/widgets/loading_widget.dart';
import 'package:pawkar_app/widgets/error_widget.dart';

class EventsListScreen extends StatefulWidget {
  @override
  State<EventsListScreen> createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
  late final NetworkListStateProvider<Event> _provider;
  late final EventService _service;

  @override
  void initState() {
    super.initState();
    _service = EventService();
    _provider = NetworkListStateProvider<Event>();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    await _provider.executeAsync(
      () => _service.getUpcomingEvents(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Loading state
    if (_provider.isLoading) {
      return LoadingWidget(message: 'Loading events...');
    }

    // Error state
    if (_provider.isError) {
      return NetworkErrorWidget(
        error: _provider.error,
        message: _provider.message,
        onRetry: _loadEvents,
      );
    }

    // Empty state
    if (_provider.data?.isEmpty ?? true) {
      return EmptyStateWidget(
        title: 'No upcoming events',
        message: 'Check back later for new events',
      );
    }

    // Success state
    return ListView.builder(
      itemCount: _provider.data!.length,
      itemBuilder: (context, index) {
        final event = _provider.data![index];
        return Card(
          child: ListTile(
            title: Text(event.title),
            subtitle: Text(event.location),
            trailing: Text('\$${event.price}'),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }
}
```

## API Endpoints Reference

### Assuming your backend follows this structure:

```
GET    /api/events                          - Get all events
GET    /api/events/featured                 - Get featured events
GET    /api/events/upcoming?limit=10        - Get upcoming events
GET    /api/events/category/:categoryName   - Get events by category
GET    /api/events/:id                      - Get single event
GET    /api/events/search?q=query           - Search events
POST   /api/events                          - Create event (admin)
PUT    /api/events/:id                      - Update event (admin)
DELETE /api/events/:id                      - Delete event (admin)
```

Adjust the endpoints in `EventService` if your API structure differs.

## Error Handling Best Practices

1. **Always provide retry functionality** - Users appreciate the ability to retry failed operations
2. **Show specific error messages** - Don't just say "Error", explain what went wrong
3. **Use appropriate icons** - Visual cues help users understand error types
4. **Implement timeouts** - All services already have 15-second timeouts
5. **Log errors** - Use `debugPrint()` for debugging during development

## Testing Tips

1. Test with slow network connections using device settings
2. Test offline by toggling airplane mode
3. Test with invalid/missing data
4. Test retry mechanisms
5. Monitor memory usage during loading states

## Next Steps

1. Replace `Environment.baseUrl` with your actual backend URL
2. Verify your API endpoints match the EventService implementation
3. Test with real data
4. Add authentication if needed
5. Consider implementing local caching for better UX
6. Add search functionality with auto-complete
7. Implement pagination for large lists

## Troubleshooting

### "Connection refused" errors
- Ensure backend is running
- Verify `Environment.baseUrl` is correct
- Check network connectivity

### "Null value" errors in models
- Verify API response structure matches model expectations
- Check for missing required fields in API responses
- Review error messages in logs

### UI not updating after API call
- Ensure provider is being disposed properly
- Check that `setState()` or `notifyListeners()` is being called
- Verify provider is not null

### Timeout errors
- Increase timeout duration if backend is slow
- Check backend response times
- Verify network connectivity

## Support

For issues or questions, refer to:
- `IMPROVEMENTS.md` - Detailed changes documentation
- Service files - Comprehensive comments and examples
- Model files - Data structure and validation logic
