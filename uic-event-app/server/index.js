const fastify = require('fastify')({ logger: true });
const PORT = process.env.PORT || 8080;

// Health Check
fastify.get('/', async (request, reply) => {
  return { status: 'ok', service: 'uic-event-api' };
});

// Check-in Endpoint
fastify.post('/api/checkin', async (request, reply) => {
  const { userId, eventCode } = request.body;
  // Placeholder for logic
  return { success: true, message: `User ${userId} checked into ${eventCode}` };
});

const start = async () => {
  try {
    await fastify.listen({ port: PORT, host: '0.0.0.0' });
    console.log(`Server running on port ${PORT}`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};
start();
